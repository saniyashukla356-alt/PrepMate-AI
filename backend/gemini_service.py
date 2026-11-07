
import os

from dotenv import load_dotenv
from google import genai

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    raise ValueError("GEMINI_API_KEY is missing from the .env file")

client = genai.Client(api_key=api_key)

def analyze_resume(resume_text, job_description):
    prompt = f"""
    You are an expert resume evaluator.

    Analyze the following resume against the job description.

    RESUME:
    {resume_text}

    JOB DESCRIPTION:
    {job_description}

    Return:
    1. ATS compatibility score out of 100.
    2. Resume strengths.
    3. Missing skills.
    4. Improvement suggestions.
    5. Job description match percentage.

    Be accurate and do not invent qualifications.
    """

    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=prompt
    )

    return response.text
