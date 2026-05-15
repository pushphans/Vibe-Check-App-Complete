from pydantic import BaseModel, ConfigDict, Field


def _to_camel(s: str) -> str:
    first, *rest = s.split("_")
    return first + "".join(w.capitalize() for w in rest)


class AnalyzeRequest(BaseModel):
    image_url: str = Field(description="Public URL of the outfit/grooming image")

    model_config = ConfigDict(
        alias_generator=_to_camel,
        populate_by_name=True,
    )


class AnalyzeResponse(BaseModel):
    vibe_score: int = Field(description="Overall vibe and aesthetic score out of 100")
    fit_score: int = Field(description="How well the outfit fits out of 100")
    verdict: str = Field(description="Crisp 2-sentence analysis of the style and fit")
    dominant_colors: list[str] = Field(
        description="Exactly 3 Hex color codes matching or complementing the outfit"
    )
    quick_fix: str = Field(
        description="A single short actionable tip to improve the look"
    )

    model_config = ConfigDict(
        alias_generator=_to_camel,
        populate_by_name=True,
    )
