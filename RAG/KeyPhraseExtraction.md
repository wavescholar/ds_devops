Extract key phrases from a set of documents that belongs to one category. Approaches; TextRank, RAKE, POS tagging

### Steps 
- **Preprocessing**:
  - Clean the text (remove stop words, punctuation, and special characters).
  - Convert text to lowercase and tokenize.
  
- **Phrase Extraction Techniques**:
  - Use **TF-IDF (Term Frequency-Inverse Document Frequency)**:
    - Identify key phrases by ranking terms based on their TF-IDF scores.
  - Leverage **RAKE (Rapid Automatic Keyword Extraction)**:
    - RAKE identifies multi-word phrases based on word frequency and co-occurrence.
  - Apply **Named Entity Recognition (NER)**:
    - Use NER models to extract named entities (e.g., persons, organizations, locations).
  - Use **BERT-based models**:
    - Fine-tune a model like BERT to identify key phrases semantically relevant to the category.

- **Output Formatting**:
  - Group phrases based on frequency or relevance scores.
  - Organize results for easy interpretation, e.g., JSON format or a clean tabular layout.

### Example Python Code
Here’s a Python implementation using `spaCy` and `RAKE`:

```python
import spacy
from rake_nltk import Rake

# Load spaCy model
nlp = spacy.load("en_core_web_sm")

# Example set of documents
documents = [
    "Natural language processing enables the extraction of key phrases.",
    "Advanced models like BERT are used for semantic analysis.",
    "TF-IDF is a common technique for ranking terms."
]

# Function for key phrase extraction using RAKE and spaCy NER
def extract_key_phrases(documents):
    rake = Rake()  # Initialize RAKE
    results = []
    for doc in documents:
        # RAKE for keyword extraction
        rake.extract_keywords_from_text(doc)
        keywords = rake.get_ranked_phrases()
        
        # spaCy NER for named entities
        spacy_doc = nlp(doc)
        named_entities = [ent.text for ent in spacy_doc.ents]
        
        # Combine results
        results.append({
            "text": doc,
            "rake_keywords": keywords,
            "named_entities": named_entities
        })
    return results

# Extract key phrases
key_phrases = extract_key_phrases(documents)

# Output results
import json
formatted_output = json.dumps(key_phrases, indent=2)
print(formatted_output)
```

### Output Example
```json
[
  {
    "text": "Natural language processing enables the extraction of key phrases.",
    "rake_keywords": ["extraction of key phrases", "natural language processing"],
    "named_entities": []
  },
  {
    "text": "Advanced models like BERT are used for semantic analysis.",
    "rake_keywords": ["semantic analysis", "advanced models like bert"],
    "named_entities": ["BERT"]
  },
  {
    "text": "TF-IDF is a common technique for ranking terms.",
    "rake_keywords": ["ranking terms", "common technique", "tf-idf"],
    "named_entities": []
  }
]
```

