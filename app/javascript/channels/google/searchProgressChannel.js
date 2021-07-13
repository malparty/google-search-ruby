import consumer from "../consumer"

consumer.subscriptions.create("Google::SearchProgressChannel", {
  // data = {:pending_count, :failed_count}
  received(data) {
    console.log(data);
  }
})
