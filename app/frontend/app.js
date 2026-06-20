const API_URL = "";

const chat = document.getElementById("chat");

function addMessage(text, css) {

    const message = document.createElement("div");

    message.className = "message " + css;

    message.innerHTML = "<div>" + text + "</div>";

    chat.appendChild(message);

    chat.scrollTop = chat.scrollHeight;

}

async function sendQuestion() {

    const questionBox = document.getElementById("question");

    const question = questionBox.value.trim();

    if(question==="") return;

    addMessage(question,"user");

    questionBox.value="";

    addMessage("Pensando...","bot");

    try{

        const response = await fetch(API_URL,{

            method:"POST",

            headers:{

                "Content-Type":"application/json"

            },

            body:JSON.stringify({

                question:question

            })

        });

        const data = await response.json();

        chat.removeChild(chat.lastChild);

        addMessage(data.answer,"bot");

    }

    catch(error){

        chat.removeChild(chat.lastChild);

        addMessage("Error al consultar la API.","bot");

    }

}