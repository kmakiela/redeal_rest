defmodule Redeal.RabbitHandler do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: RabbitHandler)
  end

  def get_deal(opening) do
    GenServer.cast(RabbitHandler, opening)
    deal = wait_for_response(5)
  end

  def wait_for_response(retry_no) do
    case :ets.lookup(:deals, :deal) do
      [] ->
        Process.sleep(100)
        if retry_no > 0 do
          wait_for_response(retry_no - 1)
        else
          "Unable to communicate to server"
        end
      [{:deal, deal}] ->
        :ets.delete(:deals, :deal)
        deal
    end
  end


  def init(_) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    # 1 exchange for both requests and responses
    AMQP.Exchange.declare(channel, "exchange", :direct)

    # 2 queue declarations, one for requests and one for responses
    AMQP.Queue.declare(channel, "requests")
    AMQP.Queue.declare(channel, "responses")

    # Bind queues to exhanage with specific keys
    AMQP.Queue.bind(channel, "requests", "exchange", routing_key: "request")
    AMQP.Queue.bind(channel, "responses", "exchange", routing_key: "response")

    # register as consumer on :responses queue
    {:ok, _} = AMQP.Basic.consume(channel, "responses")

    :deals = :ets.new(:deals, [:set, :public, :named_table])

    {:ok, %{conn: connection, channel: channel}}
  end

  def handle_cast(opening, state) do
    channel = state.channel
    AMQP.Basic.publish(channel, "exchange", "request", opening, reply_to: "responses")
    {:noreply, state}
  end

  def handle_info({:basic_consume_ok, _}, state) do
    {:noreply, state}
  end

  def handle_info({:basic_deliver, payload, metadata}, state) do
    :ets.insert(:deals, {:deal, payload})
    AMQP.Basic.ack(state.channel, metadata.delivery_tag)
    {:noreply, state}
  end

  def terminate(_reason, state) do
    AMQP.Channel.close(state.channel)
    AMQP.Connection.close(state.conn)
  end
end
