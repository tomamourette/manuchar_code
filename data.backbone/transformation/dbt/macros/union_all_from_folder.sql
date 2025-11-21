{% macro union_all_from_folder(folder_path) %}
  {%- set matching_models = [] -%}

  {# Loop through all nodes (models) in the dbt graph #}
  {% for node in graph.nodes.values() %}
    {% if node.resource_type == 'model' and folder_path in node.original_file_path %}
      {% do matching_models.append(node.name) %}
    {% endif %}
  {% endfor %}

  {%- if matching_models | length == 0 -%}
    {{ exceptions.raise("No models found in folder: " ~ folder_path) }}
  {%- endif -%}

  {# Build the UNION ALL query #}
  (
    {% for model in matching_models %}
      SELECT * FROM {{ ref(model) }}
      {% if not loop.last %} UNION ALL {% endif %}
    {% endfor %}
  )
{% endmacro %}
