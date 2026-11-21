
"""Lightweight chief complaint features for P3."""

import re
import pandas as pd


# 1. Prespecified lexical patterns

EXPLICIT_LBP = re.compile(
    r"\b(?:low|lower)\s+back\s+(?:pain|ache|aching)\b"
    r"|\bpain\s+(?:in\s+)?(?:the\s+)?(?:low|lower)\s+back\b"
    r"|\blbp\b"
    r"|\blumbar\s+(?:pain|ache)\b"
    r"|\blumbosacral\s+(?:pain|ache)\b"
    r"|\blumbago\b"
)

SCIATICA = re.compile(
    r"\bsciatic(?:a)?\b"
)

BACK_PAIN = re.compile(
    r"\bback\s+(?:pain|ache|aching)\b"
    r"|\bbackache\b"
    r"|\bback\s+(?:leg|thigh)\s+pain\b"
)

BACK_SOURCE = (
    r"(?:\b(?:low|lower)\s+back\s+(?:pain|ache)\b"
    r"|\bback\s+(?:pain|ache)\b"
    r"|\blbp\b"
    r"|\blumbago\b"
    r"|\blumbar\s+pain\b)"
)

LEG_TARGET = (
    r"(?:legs?|thighs?|feet|foot|rle|lle|ble)"
)

RADIATION = re.compile(
    BACK_SOURCE
    + r"(?:(?!\bnot\b).){0,45}?"
    + r"\b(?:radiat\w*\s+(?:to|into|down)"
    + r"|rad\s+to"
    + r"|shoot(?:s|ing)?\s+(?:to|into|down)"
    + r"|into)\s+"
    + r"(?:the\s+)?"
    + r"(?:(?:right|left|r|l)\s+)?"
    + LEG_TARGET
    + r"\b"
)

# 2. Limited assertion handling

# Retain clause boundaries before text normalization.
CLAUSE_SEPARATOR = re.compile(r"[,;|\n]+")

# Skip uncertain text after an explicit rule-out marker.
RULE_OUT = re.compile(r"\b(?:r\s*/\s*o|rule\s+out)\b")

# Treat a "versus" comparison as uncertain within its clause.
VERSUS = re.compile(r"\b(?:vs\.?|versus)\b")

NEGATION = re.compile(
    r"\b(?:no|denies?|without)\s+"
    r"(?:\w+\s+){0,2}$"
)


def normalize_rule_clause(text):
    """Normalize a clause without making clinical inferences."""
    text = text.lower()
    text = re.sub(r"[/\-]+", " ", text)
    text = re.sub(r"[^\w\s]+", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def has_affirmed_match(pattern, clause):
    """Identify matches without nearby explicit negation."""
    for match in pattern.finditer(clause):
        preceding = clause[:match.start()]

        if not NEGATION.search(preceding):
            return True

    return False


def extract_cc_features(text):
    """Extract four conservative clinical indicators."""
    features = {
        "cc_explicit_lbp": 0,
        "cc_sciatica": 0,
        "cc_broad_back_pain": 0,
        "cc_radiating_leg_pain": 0,
    }

    if pd.isna(text) or not str(text).strip():
        return features

    raw_text = str(text).strip().lower()

    # Process local clauses independently.
    for raw_clause in CLAUSE_SEPARATOR.split(raw_text):
        if not raw_clause.strip():
            continue

        # Skip comparisons containing uncertain diagnoses.
        if VERSUS.search(raw_clause):
            continue

        # Preserve affirmative text before "R/O";
        # omit the uncertain portion after it.
        raw_clause = RULE_OUT.split(raw_clause, maxsplit=1)[0]

        clause = normalize_rule_clause(raw_clause)

        if not clause:
            continue

        explicit = has_affirmed_match(EXPLICIT_LBP, clause)
        sciatica = has_affirmed_match(SCIATICA, clause)
        back_pain = has_affirmed_match(BACK_PAIN, clause)
        radiation = has_affirmed_match(RADIATION, clause)

        features["cc_explicit_lbp"] |= int(explicit)
        features["cc_sciatica"] |= int(sciatica)
        features["cc_broad_back_pain"] |= int(
            explicit or back_pain
        )
        features["cc_radiating_leg_pain"] |= int(radiation)

    return features


def add_cc_features(df):
    """Apply text rules to an encounter-level DataFrame."""
    result = df.copy()

    features = result["chiefcomplaint"].map(
        extract_cc_features
    )

    feature_df = pd.DataFrame(
        features.tolist(),
        index=result.index
    ).astype("int8")

    assert not feature_df.isna().any().any()
    assert feature_df.isin([0, 1]).all().all()

    return pd.concat([result, feature_df], axis=1)
