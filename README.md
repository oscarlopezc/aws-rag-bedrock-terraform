# AWS RAG con Amazon Bedrock, Pinecone y Terraform

Repositorio para el despliegue de una solución **Retrieval-Augmented Generation (RAG)** utilizando **Amazon Bedrock**, **Amazon S3**, **Amazon API Gateway**, **AWS Lambda**, **Amazon CloudFront**, **Pinecone** y **Terraform**.

La aplicación permite cargar documentos en Amazon S3, indexarlos en una **Knowledge Base de Amazon Bedrock** respaldada por **Pinecone** y realizar consultas desde una aplicación web mediante modelos de Inteligencia Artificial Generativa.

---

# Arquitectura

```text
Usuario
    │
    ▼
CloudFront
    │
    ▼
Amazon S3 (Frontend)
    │
    ▼
Amazon API Gateway
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
Amazon S3 Data Source
(PDF, DOCX, TXT...)
```

---

# Tecnologías utilizadas

* Terraform
* Amazon Bedrock
* Amazon Bedrock Knowledge Base
* Amazon Titan Embeddings V2
* Amazon Nova Lite (Inference Profile)
* AWS Lambda (Python 3.13)
* Amazon API Gateway
* Amazon CloudFront
* Amazon S3
* AWS IAM
* AWS Secrets Manager
* Pinecone

---

# Estructura del proyecto

```text
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
├── .github/
│   └── workflows/
│
├── .gitignore
└── README.md
```

---

# Infraestructura desplegada

Terraform aprovisiona automáticamente:

* Amazon S3 para el Frontend
* Amazon S3 para el almacenamiento de documentos
* Amazon CloudFront
* Amazon API Gateway
* AWS Lambda
* AWS IAM (Roles y Policies)
* AWS Secrets Manager
* Amazon Bedrock Knowledge Base
* Amazon Bedrock Data Source
* Pinecone como Vector Store

---

# Flujo RAG

1. El usuario realiza una pregunta desde el Frontend.
2. Amazon API Gateway recibe la solicitud.
3. AWS Lambda invoca la operación **RetrieveAndGenerate** de Amazon Bedrock.
4. Amazon Bedrock consulta la Knowledge Base.
5. La Knowledge Base recupera la información relevante desde Pinecone.
6. El modelo de lenguaje genera una respuesta utilizando el contexto recuperado.
7. Lambda devuelve la respuesta al Frontend.

---

# Requisitos

* Terraform >= 1.11
* AWS CLI
* Cuenta de AWS
* Cuenta de Pinecone
* Amazon Bedrock habilitado
* Modelo Amazon Titan Embeddings V2
* Un Inference Profile habilitado (por ejemplo Amazon Nova Lite Global)

---

# Despliegue

Inicializar Terraform

```bash
terraform init
```

Validar la configuración

```bash
terraform validate
```

Visualizar los cambios

```bash
terraform plan
```

Desplegar la infraestructura

```bash
terraform apply
```

---

# Configuración manual de Amazon Bedrock

Después del primer despliegue con Terraform es necesario realizar una configuración manual en Amazon Bedrock.

## ¿Por qué es necesario?

Actualmente el proveedor **AWS Cloud Control (`awscc`)** utilizado por Terraform no administra completamente el ciclo de vida de las **Knowledge Bases de Amazon Bedrock**. Algunos atributos y configuraciones internas no son sincronizados correctamente, lo que puede provocar que Terraform intente modificar o recrear recursos que ya existen.

Para evitar este comportamiento, la configuración inicial se realiza una única vez desde la consola de AWS y posteriormente Terraform mantiene el estado de la infraestructura sin generar cambios innecesarios.

## Pasos

1. Ingresar a **Amazon Bedrock → Knowledge Bases**.
2. Verificar la Knowledge Base creada por Terraform.
3. Configurar el **Data Source** asociado al bucket de Amazon S3.
4. Ejecutar la sincronización del Data Source.
5. Verificar que los documentos fueron indexados correctamente.
6. Configurar el **Inference Profile** que utilizará la función Lambda para generar las respuestas.

Una vez completados estos pasos, las siguientes ejecuciones de Terraform deberán mostrar:

```text
No changes. Your infrastructure matches the configuration.
```

---

# Notas importantes

* Los documentos cargados en Amazon S3 son indexados automáticamente en Pinecone mediante la Knowledge Base.
* La función Lambda utiliza la operación **RetrieveAndGenerate** de Amazon Bedrock.
* Los modelos más recientes de Amazon Bedrock requieren el uso de un **Inference Profile**, por lo que no es posible invocar directamente algunos modelos Foundation.
* La configuración de CORS del API Gateway es administrada mediante Terraform.
* El proyecto incluye un flujo de despliegue automatizado utilizando GitHub Actions.


# Estado del proyecto

**Proyecto funcional** ✅

Características implementadas:

* Infraestructura como código (Terraform)
* Frontend estático en Amazon S3
* Distribución mediante Amazon CloudFront
* API REST con Amazon API Gateway
* Backend Serverless con AWS Lambda
* Integración con Amazon Bedrock
* Base de conocimiento utilizando Pinecone
* Consulta de documentos mediante RAG
* Despliegue automatizado con GitHub Actions

---

# Autor

**Oscar López**

Arquitectura Cloud | AWS | Terraform | Amazon Bedrock | Serverless | Inteligencia Artificial Generativa
