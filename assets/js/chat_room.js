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

  function appendMessage(container, payload) {
    let messageItem = document.createElement("li")
    messageItem.dataset.role = "message"
    messageItem.innerText = `${payload.author}: ${payload.body}`
    container.appendChild(messageItem)
  }

  channel.join()
}