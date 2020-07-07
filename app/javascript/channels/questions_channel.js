import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Connected to the questions')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('#questions-list').append(`<p><a href="/questions/${data.id}">${data.title}</a></p>`)
  }
});
