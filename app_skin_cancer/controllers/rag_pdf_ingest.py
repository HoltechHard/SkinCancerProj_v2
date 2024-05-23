# ===========================
#       DATA INGESTION      #
# ===========================

import os
from langchain_community.embeddings import SentenceTransformerEmbeddings
from langchain_community.document_loaders import DirectoryLoader, UnstructuredFileLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores.qdrant import Qdrant
from qdrant_client import QdrantClient
from controllers.config import settings

#                   --- class of RAG Ingestion Process ---
class RAGIngest:
    def __init__(self):
        self.DATA_PATH = "ext_data/"
        self.PROCESSED_PATH = "models/"

    # function to load the list of processed files from a file
    def get_processed_files(self):               
        processed_files_path = os.path.join(self.PROCESSED_PATH, "processed_files.txt")
        if os.path.exists(processed_files_path):
            with open(processed_files_path, "r") as f:
                return set(f.read().splitlines())
        return set()

    # Mark the files as processed by writing them to the "processed_files.txt" file
    def mark_files_as_processed(self, file_names):        
        processed_files_path = os.path.join(self.PROCESSED_PATH, "processed_files.txt")
        with open(processed_files_path, "a") as f:
            for file_name in file_names:
                f.write(file_name + "\n")

    # function to make process of data ingest
    def process_vector_db(self):
        # Get the list of processed files
        processed_files = self.get_processed_files()

        # Load the new documents from the DATA_PATH
        loader = DirectoryLoader(path=self.DATA_PATH,
                                 glob="*.pdf",
                                 show_progress=True,
                                 loader_cls=UnstructuredFileLoader)
        documents = loader.load()    

        # Filter out the documents that have already been processed
        new_documents = [doc for doc in documents if str(doc.metadata["source"]).replace("ext_data\\", "") not in processed_files]
        
        # Split the new documents into chunks
        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1024,
                                                        chunk_overlap=50)
        new_texts = text_splitter.split_documents(new_documents)

        # Generate embeddings for the new texts
        embeddings = SentenceTransformerEmbeddings(model_name=settings["qdrant"]["embeddings"])

        # Mark the new files as processed
        self.mark_files_as_processed([str(doc.metadata["source"]).replace("ext_data\\", "") for doc in new_documents])

        # define qdrant client
        qdrant_client = QdrantClient(url = settings["qdrant"]["url"])
            
        # create from scratch or update qdrant database using new docs
        if processed_files:
            print("Qdrant database already exists. Appending new data...")
            # define qdrant db object
            qdrant = Qdrant(collection_name=settings["qdrant"]["database"],
                                embeddings=embeddings,
                                client = qdrant_client)
            # concatenate new vectors with existing vectors
            qdrant.add_documents(documents=new_texts)
        else:
            print("Creating new Qdrant database...")
            Qdrant.from_documents(documents=new_texts,
                                    embedding=embeddings,
                                    url=settings["qdrant"]["url"],
                                    #client = qdrant_client,
                                    prefer_grpc = False,
                                    collection_name = settings["qdrant"]["database"])

        print("Vector-db is updated!")

# object of ingest script
ingest_engine = RAGIngest()
