"""JSON schema definitions and pydantic models for API payloads.
Placeholders: update with real schemas when API contract is implemented.
"""

from pydantic import BaseModel


class WeekQuery(BaseModel):
    season: int
    week: int


class SeasonQuery(BaseModel):
    season: int
    include_per_week: bool = False
