defmodule Telepathy.ListenerQueries do
  import Mix.Generator

  def eventstream_query(table_name: table_name, trigger_name: trigger_name, channel_name: channel_name) do
    function_name = "notify_telepathy_" <> channel_name

    function_template(channel_name: channel_name, function_name: function_name) <>
      drop_trigger_template(trigger_name: trigger_name, table_name: table_name) <>
      create_trigger_template(trigger_name: trigger_name, table_name: table_name, function_name: function_name)
  end

  embed_template :create_trigger, """
CREATE TRIGGER <%= @trigger_name %>
AFTER INSERT OR UPDATE OR DELETE
ON <%= @table_name %>
FOR EACH ROW
EXECUTE PROCEDURE <%= @function_name %>();
  """

  embed_template :drop_trigger, """
DROP TRIGGER IF EXISTS <%= @trigger_name %> ON <%= @table_name %>;
  """

  embed_template :function, """
CREATE OR REPLACE FUNCTION <%= @function_name %>()
RETURNS trigger AS $$
BEGIN
  CASE TG_OP 
    WHEN 'INSERT' THEN
      PERFORM pg_notify(
        '<%= @channel_name %>',
        json_build_object(
          'table', TG_TABLE_NAME,
          'type', TG_OP,
          'old_data', NULL,
          'new_data', row_to_json(NEW)
        )::text
      );
    WHEN 'UPDATE' THEN
      PERFORM pg_notify(
        '<%= @channel_name %>',
        json_build_object(
          'table', TG_TABLE_NAME,
          'type', TG_OP,
          'old_data', row_to_json(OLD),
          'new_data', row_to_json(NEW)
        )::text
      );
    WHEN 'DELETE' then
      PERFORM pg_notify(
        '<%= @channel_name %>',
        json_build_object(
          'table', TG_TABLE_NAME,
          'type', TG_OP,
          'old_data', row_to_json(OLD),
          'new_data', NULL
        )::text
      );
    ELSE
      PERFORM pg_notify(
        '<%= @channel_name %>',
        json_build_object(
          'table', TG_TABLE_NAME,
          'type', TG_OP,
          'error', 'Trigger fired for unknown operation'
        )::text
      );
  END CASE;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql
RETURNS NULL ON NULL INPUT;
  """
end