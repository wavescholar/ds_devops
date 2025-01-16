import os
import json
import logging
from datetime import datetime
from multiprocessing import Pool
from sec_api import QueryApi, RenderApi
from dotenv import load_dotenv

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("sec_scraper.log"),
        logging.StreamHandler()
    ]
)

# Load environment variables
load_dotenv()
SEC_API_KEY = os.getenv('SEC_API_KEY')

if not SEC_API_KEY:
    logging.error("SEC_API_KEY is not set. Exiting.")
    exit(1)

query_api = QueryApi(api_key=SEC_API_KEY)
render_api = RenderApi(api_key=SEC_API_KEY)

def get_filings_urls():
    """Fetch filing URLs and save them to a file."""
    logging.info("Fetching filing URLs...")
    file_path = "filing_urls.txt"
    
    with open(file_path, "a") as log_file:
        for year in range(2022, 2020, -1):  # Adjust range as needed
            logging.info(f"Starting download for year {year}")
            for month in range(1, 13):
                universe_query = (
                    "formType:(\"10-K\", \"10-KT\", \"10KSB\", \"10KT405\", \"10KSB40\", \"10-K405\") AND "
                    f"filedAt:[{year}-{month:02d}-01 TO {year}-{month:02d}-31]"
                )

                base_query = {
                    "query": {
                        "query_string": {
                            "query": universe_query,
                            "time_zone": "America/New_York"
                        }
                    },
                    "from": 0,
                    "size": 200,
                    "sort": [{"filedAt": {"order": "desc"}}]
                }

                for from_batch in range(0, 400, 200):
                    base_query["from"] = from_batch
                    response = query_api.get_filings(base_query)

                    if not response["filings"]:
                        break

                    urls = [filing["linkToFilingDetails"] for filing in response["filings"]]
                    log_file.write("\n".join(urls) + "\n")

                logging.info(f"URLs downloaded for {year}-{month:02d}")

    logging.info("All URLs downloaded.")

def load_urls(file_path="filing_urls.txt"):
    """Load filing URLs from a file."""
    if not os.path.exists(file_path):
        logging.error(f"File {file_path} does not exist. Exiting.")
        return []

    with open(file_path, "r") as file:
        urls = [url.strip() for url in file if url.strip()]
    logging.info(f"Loaded {len(urls)} URLs from {file_path}.")
    return urls

def download_filing(url):
    """Download a single filing given its URL."""
    try:
        logging.info(f"Downloading filing from {url}")
        filing = render_api.get_filing(url)
        file_name = f"filings/{url.split('/')[-2]}-{url.split('/')[-1]}"

        os.makedirs("filings", exist_ok=True)

        with open(file_name, "w") as file:
            file.write(filing)

        logging.info(f"Successfully downloaded {file_name}")
    except Exception as e:
        logging.error(f"Failed to download filing from {url}: {e}")

def download_all_filings():
    """Download all filings concurrently."""
    urls = load_urls()

    if not urls:
        logging.warning("No URLs to download. Exiting.")
        return

    logging.info(f"Starting download of {len(urls)} filings.")
    with Pool(processes=4) as pool:
        pool.map(download_filing, urls)
    logging.info("All filings downloaded.")

if __name__ == "__main__":
    logging.info("Starting SEC filings scraper.")

    if not os.path.exists("filing_urls.txt"):
        get_filings_urls()

    download_all_filings()
    logging.info("SEC filings scrape complete.")
