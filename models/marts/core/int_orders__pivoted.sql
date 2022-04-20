{%- set payment_methods = ['bank_transfer', 'counpon', 'credit_card', 'gift_card'] -%}

with payments as (
    select * from {{ ref('stg_payments') }}
),

pivoted as (
    select
        order_id,

        {% for payment_method in payment_methods -%}
            sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{payment_method}}_amount
          {%- if payment_method != payment_methods[-1] -%}
            ,
          {%- endif %}
        {% endfor -%}

    from payments
    where status = 'success'
    group by 1
    order by order_id
)

select * from pivoted