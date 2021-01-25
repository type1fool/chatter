import socket from "./socket"

let chatRoomTitle = document.getElementById("chat-room-title")
if (chatRoomTitle) {
  let chatRoomName = chatRoomTitle.dataset.chatRoomName
  let channel = socket.channel(`chat_room:${chatRoomName}`, {})

  let messageForm = document.getElementById("new-message-form")
  let messageInput = document.getElementById("message")
  let messagesContainer = document.querySelector("[data-role='messages']")

  messageForm.addEventListener("submit", event => {
    event.preventDefault()
    channel.push("new_message", { body: messageInput.value.trim() })
    event.target.reset()
  })

  channel.on("new_message", payload => {
    appendMessage(messagesContainer, payload)
  })

  function appendMessage(container, { author, body }) {
    let messageItem = document.createElement("li")
    messageItem.classList.add("flex", "flex-wrap")
    messageItem.dataset.role = "message"
    let authorElement = `<span class="font-bold">${author}</span>`
    let bodyElement = `<span class="">${body}</span>`
    messageItem.innerHTML = `${authorElement} : ${bodyElement}`
    container.appendChild(messageItem)
  }

  channel.join()
    .receive("ok", resp => {
      resp.messages.map(message => {
        appendMessage(messagesContainer, message)
      })
    })
}