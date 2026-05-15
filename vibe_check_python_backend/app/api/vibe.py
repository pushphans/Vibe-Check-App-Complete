from fastapi import APIRouter, HTTPException

from app.agent.vibe_check_agent import workflow
from app.schemas.analyze import AnalyzeRequest, AnalyzeResponse

router = APIRouter(prefix="/api", tags=["vibe"])


@router.post("/analyze", response_model=AnalyzeResponse)
async def analyze_image(request: AnalyzeRequest) -> AnalyzeResponse:
    try:
        result = await workflow.ainvoke({"image_url": request.image_url})
        ui_data = result["ui_data"]
        return AnalyzeResponse(
            vibe_score=ui_data["vibe_score"],
            fit_score=ui_data["fit_score"],
            verdict=ui_data["verdict"],
            dominant_colors=ui_data["dominant_colors"],
            quick_fix=ui_data["quick_fix"],
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
