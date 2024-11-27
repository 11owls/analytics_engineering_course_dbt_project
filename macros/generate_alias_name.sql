{% macro generate_alias_name(custom_alias_name=none, node=none) -%}
    {%- if custom_alias_name is not none -%}

        {{ custom_alias_name | trim }}
    
    {%- elif node.resource_type == 'model' and target.name in ('prod') -%}
        {# if no custom alias is provided and if we are not building inside a developers schema,
            generate the alias name by removing the folder prefixes from the node name #}
        {% set alias = namespace(value=node.name) %}
        {%- for folder_name in node.fqn[1:-1] %}
            {% set alias.value = alias.value|replace(folder_name ~ '_', '') %}
        {% endfor %}

        {{ alias.value }}

    
    {%- else -%}
        
        {{ node.name }}
    
    {%- endif -%}

{%- endmacro %}