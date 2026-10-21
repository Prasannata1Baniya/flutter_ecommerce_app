from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import products, cart, orders, user

app = FastAPI(
    title="Minimalist Luxury E-Commerce API",
    description="Python FastAPI backend for Flutter Minimalist Cream & Black E-Commerce App",
    version="1.0.0"
)

# Enable CORS for Flutter Web, Mobile Emulators, Desktop & Localhost
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(products.router)
app.include_router(cart.router)
app.include_router(orders.router)
app.include_router(user.router)

@app.get("/")
def root():
    return {
        "status": "online",
        "app": "MAISON E-Commerce API",
        "aesthetic": "Cream & Black Minimalist Luxury",
        "documentation": "/docs"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
