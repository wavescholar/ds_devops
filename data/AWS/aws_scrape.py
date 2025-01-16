import requests
from bs4 import BeautifulSoup
import os

# Base URL for AWS Documentation
BASE_URL = "https://aws.amazon.com/documentation/"

# Output Directory
OUTPUT_DIR = "aws_docs"

# Function to fetch the content of a webpage
def fetch_page(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.text
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return None

# Function to parse the AWS Documentation main page and get links to categories
def get_doc_links(base_url):
    html = fetch_page(base_url)
    if not html:
        return []
    soup = BeautifulSoup(html, "html.parser")
    links = []

    # Find all documentation category links
    for a_tag in soup.find_all("a", href=True):
        href = a_tag['href']
        if "/documentation/" in href:
            links.append(href)

    # Ensure URLs are absolute
    links = [link if link.startswith("https://") else f"https://aws.amazon.com{link}" for link in links]
    return list(set(links))  # Remove duplicates

# Function to scrape a single documentation page
def scrape_page(url):
    html = fetch_page(url)
    if not html:
        return None
    soup = BeautifulSoup(html, "html.parser")

    # Extract title, headings, and paragraphs
    title = soup.title.string if soup.title else "Untitled"
    content = []

    # Find all relevant content (headings and paragraphs)
    for element in soup.find_all(["h1", "h2", "h3", "p"]):
        text = element.get_text(strip=True)
        if text:
            content.append(text)

    return {"url": url, "title": title, "content": "\n".join(content)}

# Function to save content to a file
def save_content(doc, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    filename = os.path.join(output_dir, f"{doc['title'].replace('/', '_')}.txt")
    with open(filename, "w", encoding="utf-8") as f:
        f.write(f"URL: {doc['url']}\n\n")
        f.write(f"Title: {doc['title']}\n\n")
        f.write(doc['content'])

# Main scraper logic
def main():
    print("Scraping AWS Documentation...")
    doc_links = get_doc_links(BASE_URL)
    print(f"Found {len(doc_links)} documentation links.")

    for link in doc_links:
        print(f"Scraping {link}...")
        doc = scrape_page(link)
        if doc:
            save_content(doc, OUTPUT_DIR)
            print(f"Saved: {doc['title']}")

if __name__ == "__main__":
    main()
