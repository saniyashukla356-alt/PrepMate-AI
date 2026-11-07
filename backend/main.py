
from io import BytesIO
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from pypdf import PdfReader

from gemini_service import analyze_resume

app = FastAPI(
    title="PrepMate AI",
    description="AI-powered Resume Analysis and Interview Preparation Platform",
    version="1.0.0"
)
app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
def extract_pdf_text(content):
    reader = PdfReader(BytesIO(content))
    extracted_text = "\n".join(
        page.extract_text() or "" for page in reader.pages
    )

    if not extracted_text.strip():
        raise ValueError("No readable text found in this PDF.")

    return extracted_text, len(reader.pages)

@app.get("/")
def home():
    return {
        "message": "Welcome to PrepMate AI Backend!",
        "status": "Running"
    }

@app.get("/health")
def health_check():
    return {
        "status": "healthy"
    }

@app.post("/resume/extract")
async def extract_resume(file: UploadFile = File(...)):
    if not file.filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are supported.")

    content = await file.read()

    if not content.startswith(b"%PDF"):
        raise HTTPException(status_code=400, detail="Invalid PDF file.")

    try:
        extracted_text, total_pages = extract_pdf_text(content)

        return {
            "filename": file.filename,
            "total_pages": total_pages,
            "extracted_text": extracted_text
        }

    except ValueError as error:
        raise HTTPException(status_code=400, detail=str(error))

    except Exception:
        raise HTTPException(status_code=400, detail="Unable to process this PDF.")

@app.post("/resume/analyze")
async def resume_analysis(
    file: UploadFile = File(...),
    job_description: str = Form(...)
):
    if not file.filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are supported.")

    if not job_description.strip():
        raise HTTPException(status_code=400, detail="Job description is required.")

    content = await file.read()

    if not content.startswith(b"%PDF"):
        raise HTTPException(status_code=400, detail="Invalid PDF file.")

    try:
        resume_text, total_pages = extract_pdf_text(content)

        analysis = analyze_resume(resume_text, job_description)

        return {
            "filename": file.filename,
            "total_pages": total_pages,
            "analysis": analysis
        }

    except ValueError as error:
        raise HTTPException(status_code=400, detail=str(error))

    except Exception as error:
        raise HTTPException(status_code=500, detail=f"Resume analysis failed: {str(error)}")
