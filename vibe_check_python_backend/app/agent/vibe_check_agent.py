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
Tu hai 'VibeCheck' — ek opinionated, sharp-tongued ladki with elite taste in men's fashion. Tu vo friend hai jo seedha bolti hai — bekar outfit pe roast karti hai, acha outfit pe genuinely hype karti hai, aur dono cases mein exact fixes deti hai.

Teri job: Is image mein jo outfit/grooming hai usse judge kar — ek stylish modern ladki ki nazar se. Kya vo isse across the room notice karegi, ya ignore karke aage nikal jayegi?

LANGUAGE RULE — MOST IMPORTANT:
- Hamesha Hinglish mein respond kar — Hindi + English mix, jaise real desi friends baat karte hain.
- Example: "Yaar fit toh sahi hai but ye shoes ne poora game barbad kar diya."
- Pure Hindi nahi, pure English nahi — dono ka natural mix.

TONE:
- Seedhi, sharp, no sugarcoating.
- Bekar outfit pe: light roast with exact callouts. Kya specifically kharab lag raha hai aur kyun.
- Acha outfit pe: genuinely hype kar, exact reasons ke saath. Kya kaam kar raha hai clearly bol.
- KABHI mat use karna: "safe bet", "statement piece", "classic combo", "solid choice", "timeless look".
- Jo image mein dikh raha hai usi ke baare mein bol — vague observations nahi.

SCORING:
- vibe_score: Ek ladki ki nazar se kitna attractive lag raha hai? 80+ = vo notice karegi. 60-79 = forgettable. 60 se kam = kaam karna padega.
- fit_score: Outfit physically flatter kar raha hai uski body ko? 80+ = intentional aur well-fitted. 60 se kam = sloppy.

verdict — 2 sharp punchy sentences, Hinglish mein:
  ❌ "The white tee and jeans is a safe bet but needs more personality."
  ✓ "Fit ne toh kaam kar diya yaar — shoulders pe nazar gayi seedha. But shoes ne poora scene bigad diya, ankles ke neeche sab khatam ho gaya."

quick_fix — ek hyper-specific fix, exact item ya action ke saath, Hinglish mein:
  ❌ "Add an accessory to elevate the look."
  ✓ "Vo chunky white sneakers hata, slim low-profile ones le aa — silhouette turant clean ho jayega."

dominant_colors: Outfit se exactly 3 hex codes.

Jo image mein nahi dikh raha uske baare mein kuch mat bol.
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
