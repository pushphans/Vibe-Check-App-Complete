from typing import Annotated, Optional, TypedDict

from langchain.chat_models import init_chat_model
from langchain.messages import AnyMessage, HumanMessage, SystemMessage
from langgraph.graph import END, START, StateGraph, add_messages
from pydantic import BaseModel, Field
from app.core.config import settings


# =======================
# State
# =======================
class AgentState(TypedDict):
    image_url: str
    ui_data: Optional[dict]


# =======================
# LLM initialization
# =======================
llm = init_chat_model(
    model="gpt-4o", model_provider="openai", api_key=settings.OPENAI_API_KEY
)


# =======================
# Agent definition
# ======================
class VibeAnalysis(BaseModel):
    vibe_score: int = Field(description="Overall vibe and aesthetic score out of 100")
    fit_score: int = Field(description="How well the outfit fits out of 100")
    verdict: str = Field(description="Crisp 2-sentence analysis of the style and fit")
    dominant_colors: list[str] = Field(
        description="Exactly 3 Hex color codes matching or complementing the outfit, e.g., ['#00F2FF', '#FF6B6B', '#00D2D3']",
        min_length=3,
        max_length=3,
    )
    quick_fix: str = Field(
        description="A single short actionable tip to improve the look"
    )


vibe_llm = llm.with_structured_output(schema=VibeAnalysis)


# =======================
# Nodes
# =======================
async def analyze_vibe_node(state: AgentState) -> AgentState:
    image_url = state["image_url"]
    human_message = HumanMessage(
        content=[
            {"type": "text", "text": "Analyze this outfit and grooming."},
            {"type": "image_url", "image_url": {"url": image_url}},
        ]
    )
    system_message = SystemMessage(content="""
You are 'VibeCheck', an elite Gen-Z AI fashion and grooming stylist operating in 2026. 
Your task is to analyze the user's uploaded outfit or grooming image and provide highly accurate, sharp, and constructive feedback.

Focus your analysis on:
1. Overall aesthetic appeal, current trends, and styling (Vibe).
2. Body proportions, face shape compatibility, and tailoring (Fit).
3. Color theory and visual harmony.

Extract the information strictly based on the provided image to match the required schema:
- vibe_score: Integer (0-100) representing overall trendiness and coolness.
- fit_score: Integer (0-100) representing how well the clothes or grooming fit the user physically.
- verdict: A crisp, punchy 2-sentence analysis of the style, fit, and visual balance. Keep it modern and edgy.
- dominant_colors: Exactly 3 Hex color codes (e.g., "#00F2FF", "#121212") representing the outfit's core palette or best complementary colors.
- quick_fix: A single, short, actionable tip to instantly elevate the look (e.g., "Add a silver chain", "Tuck in the shirt to define the waist").

Do not hallucinate details not visible in the image. Be precise and objective.
""")

    response = await vibe_llm.ainvoke([system_message, human_message])
    return {
        "ui_data": response.model_dump(),
    }


# =======================
# Graph
# ======================
graph = StateGraph(state_schema=AgentState)
graph.add_node("analyze_vibe_node", analyze_vibe_node)

graph.add_edge(START, "analyze_vibe_node")
graph.add_edge("analyze_vibe_node", END)


# =======================
# Compiled Graph
# ======================
workflow = graph.compile()
