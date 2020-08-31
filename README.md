# Shopping cart microservice

This document will describe how to setup the app and provide a brief overview of [the task](the_task.md).

## Application setup
Local setup (Ruby 2.6.6 is required):
```
./bin/setup
```
Docker container:
```
docker-compose up --build
```
To run specification:
```
rspec spec
```

## An example of API use with cURL requests
_All examples are provided for local setup. In case of running the application containerized, please, change `localhost:3000` to the corresponding resource_

**To create a persistant shopping cart:**
```
curl -X POST http://localhost:3000/users/1/carts -d 'cart[user_id]=1'
```

<details>
  <summary>Response:</summary>
```json
{
  "data": {
    "id": "24",
    "type": "cart",
    "attributes": {
      "user_id": 1,
      "created_at": "2020-08-31T10:28:34.040Z",
      "updated_at": "2020-08-31T10:28:34.040Z"
    },
    "relationships": {
      "line_items": {
        "data": []
      }
    }
  }
}
```
</details>

**To add line item to the shopping cart:**
```
curl -X POST http://localhost:3000/users/1/carts/24/line_items \
-d 'line_item[cart_id]=24' \
-d 'line_item[product_id]=1' \
-d 'line_item[quantity]=1' \
-d 'line_item[title]=product' \
-d 'line_item[price]=42'
```

<details>
  <summary>Response:</summary>
```json
{
  "data": {
    "id": "222",
    "type": "line_item",
    "attributes": {
      "product_id": 1,
      "quantity": 1,
      "title": "product",
      "price": "42.0",
      "created_at": "2020-08-31T10:40:25.078Z",
      "updated_at": "2020-08-31T10:40:25.078Z"
    },
    "relationships": {
      "cart": {
        "data": {
          "id": "24",
          "type": "cart"
        }
      }
    }
  }
}
```
</details>

**To remove line item from the shopping cart:**

```
curl -X DELETE http://localhost:3000/users/1/carts/24/line_items/222
```

**To empty the shopping cart:**

- The client can remove all items one by one from the shopping cart as it is shown in the example above.

- Or remove shopping cart:
  ```
  curl -X DELETE http://localhost:3000/users/1/carts/24
  ```

- Or create a new shopping cart to use as an empty one:
  ```
  curl -X POST http://localhost:3000/users/1/carts -d 'cart[user_id]=1'
  ```

**To get the details of the cart:**
```
curl http://localhost:3000/users/1/carts/1
```

<details>
  <summary>Response:</summary>
```json
{
  "data": {
    "id": "1",
    "type": "cart",
    "attributes": {
      "user_id": 1,
      "created_at": "2020-08-30T19:39:40.258Z",
      "updated_at": "2020-08-30T19:39:40.258Z"
    },
    "relationships": {
      "line_items": {
        "data": [
          {
            "id": "1",
            "type": "line_item"
          },
          {
            "id": "2",
            "type": "line_item"
          }
        ]
      }
    }
  },
  "included": [
    {
      "id": "1",
      "type": "line_item",
      "attributes": {
        "product_id": 1,
        "quantity": 1,
        "title": "Product Title 1",
        "price": "42.0",
        "created_at": "2020-08-30T19:39:40.296Z",
        "updated_at": "2020-08-30T19:39:40.296Z"
      },
      "relationships": {
        "cart": {
          "data": {
            "id": "1",
            "type": "cart"
          }
        }
      }
    },
    {
      "id": "2",
      "type": "line_item",
      "attributes": {
        "product_id": 2,
        "quantity": 1,
        "title": "Product Title 2",
        "price": "42.0",
        "created_at": "2020-08-30T19:39:40.302Z",
        "updated_at": "2020-08-30T19:39:40.302Z"
      },
      "relationships": {
        "cart": {
          "data": {
            "id": "1",
            "type": "cart"
          }
        }
      }
    }
  ]
}
```
</details>

## Task overview

Here is the database representation of the monolith application [schema provided](https://drawsql.app/ro/diagrams/oms/embed):
![](https://user-images.githubusercontent.com/2729803/91714220-8b673600-eb8b-11ea-8f6c-d265d373317f.png)

As using shared database to build microservices is a common anti-pattern first thing we would need to do is to restructure the existing database.

To properly extract the data layer from the monolith to the microservice we need to take into account numerous things. Such as what challenges do we have or going to have in the project (high-load, load spikes, performance restrictions in time or resources). What functionality are we going to have and how our system is going to look like to provide it. What features do we provide right now and how they are going to be migrated.

Since the information of that wasn't provided for the task here is three common ways to split OMS and shopping cart system for the provided schema:

##### Use `orders -> line_items` tables to store the shopping list
![](https://user-images.githubusercontent.com/2729803/91718600-f9aff680-eb93-11ea-9377-790edc06fd7e.png)
By eliminating `carts` we greatly simplify schema. From here we can go by two different routes.

First, we can use orders table to hold information of uncompleted orders which basically can represent user's shopping cart. That's the way as Spree and many other ecommerce frameworks work. The biggest disadvantage would be that two microservices would be dependent on one database.

Second, we can use front end application to manage unfinished orders and store information about them at the front-end side. This way we eliminate a need of having shopping cart microservice at all. Which makes it the most performant and the cheapest type of microservice to have.  The biggest disadvantage would be if we would need to synchronise shopping cart between different user's devices.

##### Extract carts table with line_items
![](https://user-images.githubusercontent.com/2729803/91718686-2c59ef00-eb94-11ea-9f51-43733fc693ec.png)

The main disadavantage of this way that we link orders to products through another service which increate complexity. And makes OMS functionality dependable on other microservice.

##### Separate line_items tables for carts and orders tables
![](https://user-images.githubusercontent.com/2729803/91719139-0ed95500-eb95-11ea-9fa9-e7194b25d478.png)

The main disadvantage of this way is that we store almost indentical data between two microservices. But this greatly benefit us in terms of performance and independability between two microservices.

That's the way this shopping_cart API is implemented in the provided application.
