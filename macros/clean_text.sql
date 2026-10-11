-- macro to handle empty freetext and spaces

{% macro clean_text(column, lowercase=false) %}
    {% if lowercase %}
        nullif(lower(trim({{ column }})), '')
    {% else %}
        nullif(trim({{ column }}), '')
    {% endif %}
{% endmacro %}