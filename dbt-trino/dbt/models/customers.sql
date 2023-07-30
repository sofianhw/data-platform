with customers as (

    select
        id  as customer_id,
        name
    from mysql.sample.people

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        created_at as order_date
    from postgres.public.orders

),

customer_orders as (

    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by 1

),


final as (

    select
        customers.customer_id,
        customers.name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
    from customers
    left join customer_orders on customer_orders.customer_id = customers.customer_id

)

select * from final