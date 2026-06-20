# 🚀 AWS RAG with Amazon Bedrock, Pinecone and Terraform

Repositorio para el despliegue de una arquitectura **Retrieval-Augmented Generation (RAG)** utilizando **Amazon Bedrock**, **Amazon S3**, **Pinecone**, **AWS Lambda**, **API Gateway**, **CloudFront** y **Terraform**.

---

# Arquitectura

```
Usuario
    │
    ▼
CloudFront
    │
    ▼
S3 (Frontend)
    │
    ▼
API Gateway
    │
    ▼
AWS Lambda (Python)
    │
    ▼
Amazon Bedrock
(RetrieveAndGenerate)
    │
    ▼
Knowledge Base
    │
    ▼
Pinecone Vector Database
    ▲
    │
S3 Data Source
(PDF, DOCX, TXT...)
```

---

# Tecnologías utilizadas

- Terraform
- Amazon Bedrock
- Amazon Bedrock Knowledge Base
- AWS Lambda
- Amazon API Gateway
- Amazon S3
- Amazon CloudFront
- AWS IAM
- AWS Secrets Manager
- Pinecone
- Python 3.13

---

# Estructura del proyecto

```
Proyecto_aws-rag-bedrock-terraform/

├── app/
│   ├── frontend/
│   └── lambda/
│
├── terraform/
│   ├── api_gateway.tf
│   ├── bedrock.tf
│   ├── cloudfront.tf
│   ├── iam.tf
│   ├── lambda.tf
│   ├── locals.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── s3_datasource.tf
│   ├── s3_frontend.tf
│   ├── secrets_manager.tf
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   └── versions.tf
│
├── .gitignore
└── README.md
```

---

# Infraestructura

La infraestructura es desplegada completamente mediante Terraform e incluye:

- Amazon Bedrock Knowledge Base
- Pinecone como Vector Store
- Amazon S3 para almacenamiento de documentos
- Amazon S3 para el Frontend
- AWS Lambda
- Amazon API Gateway
- Amazon CloudFront
- AWS Secrets Manager
- IAM Roles y Policies

---

# Flujo RAG

1. El usuario envía una pregunta desde el Frontend.
2. API Gateway recibe la solicitud.
3. Lambda invoca Amazon Bedrock.
4. Bedrock consulta la Knowledge Base.
5. La Knowledge Base recupera información desde Pinecone.
6. Claude 3.5 Sonnet genera la respuesta.
7. Lambda devuelve la respuesta al Frontend.

---

# Requisitos

- Terraform >= 1.11
- AWS CLI
- Cuenta AWS
- Pinecone
- Amazon Bedrock habilitado
- Modelo Claude 3.5 Sonnet habilitado
- Modelo Titan Embeddings habilitado

---

# Despliegue

Inicializar Terraform

```bash
terraform init
```

Validar configuración

```bash
terraform validate
```

Visualizar cambios

```bash
terraform plan
```

Desplegar infraestructura

```bash
terraform apply
```

---

# Destruir infraestructura

```bash
terraform destroy
```

---

# Estado del proyecto

En desarrollo 🚧

Próximos pasos:

- Desarrollo de la función Lambda
- Desarrollo del Frontend
- Integración completa con Amazon Bedrock
- Automatización mediante GitHub Actions

---

# Autor

Oscar López Cobo

Proyecto académico de Arquitectura Cloud utilizando Amazon Web Services (AWS).