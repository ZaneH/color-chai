defmodule MessageConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  defp create_message(channel_id, file, msg_id) do
    Api.create_message(
      channel_id,
      file: file,
      message_reference: %{message_id: msg_id}
    )
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "#" <> hex_code ->
        file = Image.create_image(hex_code: hex_code)
        create_message(msg.channel_id, file, msg.id)

      "rgb(" <> rgb_code ->
        file = Image.create_image(rgba: rgb_code)
        create_message(msg.channel_id, file, msg.id)

      "rgba(" <> rgba_code ->
        file = Image.create_image(rgba: rgba_code)
        create_message(msg.channel_id, file, msg.id)

      "hsl(" <> hsl_code ->
        file = Image.create_image(hsla: hsl_code)
        create_message(msg.channel_id, file, msg.id)

      "hsla(" <> hsla_code ->
        file = Image.create_image(hsla: hsla_code)
        create_message(msg.channel_id, file, msg.id)

      _ ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end
end
