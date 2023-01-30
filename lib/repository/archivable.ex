defmodule Repository.Archivable do
  defmacro __using__(_opts) do
    quote do
      import Ecto.Query, only: [from: 2]

      @spec unarchived(Ecto.Queryable.t()) :: Ecto.Query.t()
      def unarchived(queryable \\ __MODULE__) do
        from q in queryable, where: is_nil(q.archived_at)
      end

      @spec archived(Ecto.Queryable.t()) :: Ecto.Query.t()
      def archived(queryable \\ __MODULE__) do
        from q in queryable, where: not is_nil(q.archived_at)
      end

      @spec archive_changeset(t()) :: Ecto.Changeset.t()
      def archive_changeset(record) do
        record
        |> cast(%{"archived_at" => DateTime.utc_now()}, [:archived_at])
      end
    end
  end
end
