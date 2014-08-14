defmodule RiakCore do
  defmacro __using__(_opts) do
    quote do
      @behaviour :riak_core_vnode

      def init(_) do
        {:ok}
      end

      def handle_command(:ping, _Sender, state) do
        {:reply, :pong, state}
      end

      def handle_handoff_command(_message, _sender, state) do
        {:noreply, state}
      end

      def handoff_starting(_TargetNode, state) do
        {true, state}
      end

      def handoff_cancelled(state) do
        {:ok, state}
      end

      def handoff_finished(_TargetNode, state) do
        {:ok, state}
      end

      def handle_handoff_data(_Data, state) do
        {:reply, :ok, state}
      end

      def encode_handoff_item(_ObjectName, _ObjectValue) do
        <<>>
      end

      def is_empty(state) do
        {true, state}
      end

      def delete(state) do
        {:ok, state}
      end

      def handle_coverage(_req, _keySpaces, _sender, state) do
        {:stop, :not_implemented, state}
      end

      def handle_exit(_Pid, _Reason, state) do
        {:noreply, state}
      end

      def terminate(_Reason, _State) do
        :ok
      end

      defoverridable [
        delete: 1,
        encode_handoff_item: 2,
        handle_command: 3,
        handle_coverage: 4,
        handle_exit: 3,
        handle_handoff_command: 3,
        handle_handoff_data: 2,
        handoff_cancelled: 1,
        handoff_finished: 2,
        handoff_starting: 2,
        init: 1,
        is_empty: 1,
        terminate: 2
      ]
    end
  end
end
