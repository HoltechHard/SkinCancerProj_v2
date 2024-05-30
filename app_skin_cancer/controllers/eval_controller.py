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
from sklearn.metrics.pairwise import cosine_similarity
# 
import os 
from ragas.metrics import faithfulness, answer_relevancy, context_precision, context_recall
from ragas import evaluate
from datasets import Dataset

# global variables
AIMODEL_PATH = "ai_engine/"

# set virtual environment variable
os.environ['OPENAI_API_KEY'] = 'sk-proj-dknPaXjPR32xWYZ6t3DvT3BlbkFJrHdLNxPZreG0XZaDd2zy'

#       --- class Biomistral-7B RAG Engine ---

class BioMistralRAGEngine:

    # function to initialize BioMistral model RAG
    def __init__(self):

        # define prompt template        
        self.custom_prompt_template = """Use the following pieces of retrieved information to answer the user's question.
            If you don't know the answer, just say that you don't know the answer.
            In the case of questions with multiple choice, select the best answer and justify.
            Context: {context}
            Question: {question}
            Only provide helpful answer. Provide the answer which should be a most technical, question related and well explained answer as possible.
            Helpful answer:
        """

        # set prompt
        self.prompt = self.set_custom_prompt()

        # load model
        self.model = self.load_llm()

        # get embeddings
        self.embeddings = self.get_embeddings()

    # function to set prompt template QA retrieval
    def set_custom_prompt(self):
        prompt = PromptTemplate(template = self.custom_prompt_template,
                                input_variables = ['context', 'question'])
        return prompt

    # function to load large language model
    def load_llm(self):
        llm = LlamaCpp(
            model_path = AIMODEL_PATH + "BioMistral-7B.Q4_K_M.gguf",
            temperature = 0.2,
            max_new_tokens = 2048,
            n_ctx = 4096
        )

        return llm

    # function to get embeddings
    def get_embeddings(self):
        embeddings = SentenceTransformerEmbeddings(model_name = settings["qdrant"]["embeddings"])

        return embeddings

    # function to define QA retrieval chain
    def retrieval_qa_chain(self, db):
        qa_chain = RetrievalQA.from_chain_type(
            llm = self.model,   # llm
            chain_type = "stuff",
            retriever = db.as_retriever(search_kwargs = {'k': 6}),  # vector db
            return_source_documents = True,
            chain_type_kwargs = {'prompt': self.prompt}     # prompt
        )

        return qa_chain
    
    # function to re-rank documents based on cosine similarity
    def re_rank_documents(self, question, documents):
        question_embedding = self.embeddings.embed_query(question)
        doc_embeddings = [self.embeddings.embed_documents([doc.page_content])[0] for doc in documents]
        
        # Calculate cosine similarities
        similarities = cosine_similarity([question_embedding], doc_embeddings)[0]
        
        # Combine documents with their similarity scores
        scored_documents = list(zip(documents, similarities))
        
        # Sort documents by their similarity scores in descending order
        ranked_documents = sorted(scored_documents, key=lambda x: x[1], reverse=True)
        
        # Return only the documents, sorted by relevance
        return [doc for doc, score in ranked_documents]
    
    # function to define bot
    def qa_bot(self):
        client_db = QdrantClient(url = settings["qdrant"]["url"], prefer_grpc = False)
        db = Qdrant(client = client_db,
                    embeddings = self.embeddings,
                    collection_name = settings["qdrant"]["database"])
        qa = self.retrieval_qa_chain(db)

        return qa

    # get answer result
    def get_answer(self, question):
        print("Answer is processing...")
        qa_chain = self.qa_bot()

        # Perform initial retrieval
        initial_result = qa_chain.invoke({'query': question})
        
        # Re-rank documents based on their relevance to the question
        re_ranked_docs = self.re_rank_documents(question, initial_result['source_documents'])

        # Update the context in the prompt with the top re-ranked documents
        re_ranked_context = "\n".join([doc.page_content for doc in re_ranked_docs[:3]])  # Limit to top 3 documents

        # Get the final answer using the re-ranked context
        final_answer = qa_chain.invoke({'context': re_ranked_context, 'query': question})
        
        return final_answer, re_ranked_context

    # function to get ragas evaluation 
    def get_evaluation(self, question, true_answer, ref_answer, gen_answer):
        print("Evaluation is processing...")

        # list of metrics
        metrics = [
            faithfulness,
            answer_relevancy,
            context_precision,
            context_recall
        ]

        # dataset for evaluation
        eval_dataset = Dataset.from_dict({
            "question": [question],
            "ground_truth": [true_answer],
            "answer": [ref_answer],
            "contexts": [[gen_answer]]
        })

        # evaluate using ragas
        metric_results = evaluate(dataset = eval_dataset,
                                    metrics = metrics,
                                    raise_exceptions = False)

        return metric_results

biomistral_engine = BioMistralRAGEngine()
