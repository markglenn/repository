defmodule Repository.Archivable do
  defmacro __using__(_opts) do
    quote do
      import Ecto.Query, only: [from: 2]

      @spec unarchived(Ecto.Queryable.t()) :: Ecto.Query.t()
      @doc """
      Return only unarchived records
      """
      def unarchived(queryable \\ __MODULE__),
        do: from(q in queryable, where: is_nil(q.archived_at))

      @spec archived(Ecto.Queryable.t()) :: Ecto.Query.t()
      @doc """
      Return only archived records
      """
      def archived(queryable \\ __MODULE__),
        do: from(q in queryable, where: not is_nil(q.archived_at))
    end
  end
end
