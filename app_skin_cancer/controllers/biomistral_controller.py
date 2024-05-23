# ===================================
#       BIOMISTRAL MODEL BUILD      #
# ===================================

# import packages
from langchain.prompts import PromptTemplate
from langchain.chains import RetrievalQA
from langchain_community.llms.llamacpp import LlamaCpp
from langchain_community.embeddings import SentenceTransformerEmbeddings
from langchain_community.vectorstores.qdrant import Qdrant
from qdrant_client import QdrantClient
from controllers.config import settings

# global variables
AIMODEL_PATH = "ai_engine/"

class BioMistralRAGEngine:

    # initialize BioMistral model RAG
    def __init__(self):

        # define prompt template        
        self.custom_prompt_template = """Use the following pieces of information to answer the user's question.
            If you don't know the answer, just say that you don't know the answer.
            In the case of questions with multiple choice, select the best answer and justify.
            Context: {context}
            Question: {question}
            Only provide helpful answer. Provide the answer which should be a most detailed and well explained answer as possible.
            Helpful answer:
        """

        # set prompt
        self.prompt = self.set_custom_prompt()

        # load model
        self.model = self.load_llm()

        # get embeddings
        self.embeddings = self.get_embeddings()

    # prompt template QA retrieval
    def set_custom_prompt(self):
        prompt = PromptTemplate(template = self.custom_prompt_template,
                                input_variables = ['context', 'question'])
        return prompt

    # load large language model
    def load_llm(self):
        llm = LlamaCpp(
            model_path = AIMODEL_PATH + "BioMistral-7B.Q4_K_M.gguf",
            temperature = 0.2,
            max_new_tokens = 2048,
            n_ctx = 3072
        )

        return llm

    # get embeddings
    def get_embeddings(self):
        embeddings = SentenceTransformerEmbeddings(model_name = settings["qdrant"]["embeddings"])

        return embeddings

    # define QA retrieval chain
    def retrieval_qa_chain(self, db):
        qa_chain = RetrievalQA.from_chain_type(
            llm = self.model,   # llm
            chain_type = "stuff",
            retriever = db.as_retriever(search_kwargs = {'k': 5}),  # vector db
            return_source_documents = True,
            chain_type_kwargs = {'prompt': self.prompt}     # prompt
        )

        return qa_chain
    
    # define bot
    def qa_bot(self):
        client_db = QdrantClient(url = settings["qdrant"]["url"], prefer_grpc = False)
        db = Qdrant(client = client_db,
                    embeddings = self.embeddings,
                    collection_name = settings["qdrant"]["database"])
        qa = self.retrieval_qa_chain(db)

        return qa

    # get answer result
    def get_answer(self, query):
        print("Answer is processing...")
        qa_result = self.qa_bot()
        response = qa_result.invoke({'query': query})

        return response

biomistral_engine = BioMistralRAGEngine()
