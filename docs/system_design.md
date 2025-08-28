# System Design: Real-Time News Analysis

## 1. Purpose

The primary goal of this system is to provide traders, analysts, and financial enthusiasts with immediate, actionable insights from breaking news. In financial markets, information velocity is a critical advantage. A news headline can move markets in seconds. This system is designed to automate the process of:

1.  **Ingestion**: Continuously monitoring a stream of financial news.
2.  **Analysis**: Using a Large Language Model (LLM) to instantly extract key financial metrics and sentiment.
3.  **Presentation**: Displaying these insights in a low-latency, easy-to-digest user interface.

By doing so, it aims to reduce the cognitive load on the user and shorten the time from news-break to informed decision-making.

## 2. System Architecture

The system is composed of three main components: a **News Fetcher**, a **Backend Service**, and a **Frontend Application**.

 <!-- Placeholder for a diagram -->

### a. News Fetcher (within Backend)

-   **Source**: Google News RSS Feed (`news.google.com/rss`).
-   **Mechanism**: The `feedparser` library is used to poll the RSS feed. We specifically query for recent news (`when:1h`) to keep the data fresh.
-   **Frequency**: The system polls for new articles every 15 seconds. This is a trade-off between real-time updates and avoiding rate-limiting.

### b. Backend Service (FastAPI)

-   **Framework**: FastAPI was chosen for its high performance and native support for `async` operations, which is ideal for I/O-bound tasks like fetching news and calling external APIs.
-   **LLM Integration**: The `instructor` library, in conjunction with `Pydantic`, is used to get structured, validated JSON output from the LLM. This is crucial for reliability. If the LLM output doesn't match the `Pydantic` model, `instructor` will automatically retry, ensuring the data we process is always in the correct format.
-   **Logging**: `loguru` is used for clear, structured logging, which is essential for debugging a distributed system.
-   **Communication**: A WebSocket (`/ws`) provides a persistent, bidirectional connection to the frontend, allowing the server to push new analysis results to clients the moment they are ready.

### c. Frontend Application (Streamlit)

-   **Framework**: Streamlit was chosen for its simplicity and speed in building data-centric web applications.
-   **Real-Time Updates**: The app uses the `websockets` library to connect to the FastAPI backend. It listens for incoming messages and dynamically updates the UI with new articles and their analyses without requiring a page refresh.
-   **User Interface**: The UI is designed to be clean and intuitive, showing the most important information (sentiment, KPIs) at a glance, with options to expand for more detail.

## 3. Cost Analysis

Cost is a critical factor in any production system. The primary operational cost of this application is the LLM API usage. Let's break it down.

**Assumptions**:

-   **LLM Provider**: Cerebras API (pricing is hypothetical).
-   **Model**: A hypothetical `gpt-oss-small` model.
-   **Pricing**: Let's assume a price of **$0.002 per 1,000 input tokens** and **$0.005 per 1,000 output tokens**.
-   **Polling Frequency**: 4 times per minute (every 15 seconds).
-   **Average Article Size**: 300 tokens (summary from RSS).
-   **Average Analysis Size**: 100 tokens (structured JSON output).

**Calculation**:

1.  **API Calls per Day**:
    `4 calls/minute * 60 minutes/hour * 24 hours/day = 5,760 calls/day`

2.  **Cost per API Call**:
    -   Input Cost: `(300 tokens / 1000) * $0.002 = $0.0006`
    -   Output Cost: `(100 tokens / 1000) * $0.005 = $0.0005`
    -   Total Cost per Call: `$0.0006 + $0.0005 = $0.0011`

3.  **Total Daily Cost**:
    `5,760 calls/day * $0.0011/call = $6.336 per day`

4.  **Total Monthly Cost**:
    `$6.336/day * 30 days/month ≈ $190.08 per month`

**Conclusion**:

The estimated monthly cost to run this service is approximately **$190**. This cost could be optimized by:

-   **Reducing Polling Frequency**: Polling every 30 or 60 seconds would cut costs by 50-75%.
-   **Using a Smaller Model**: A smaller, fine-tuned model could be cheaper and faster for this specific task.
-   **Implementing a Cache**: Caching results for identical articles if they appear in multiple feeds.
