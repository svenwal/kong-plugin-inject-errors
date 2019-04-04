# kong-plugin-random-latency
A Kong plugin which adds a random latency to request in order to simulate bad networks

## configuration parameters
|FORM PARAMETER|DEFAULT|DESCRIPTION|
|:----|:------:|------:|
|config.minimum_latency_msec|0|This parameter describes the minimum latency (msec) to be added|
|config.maximum_latency_msec|1000|This parameter describes the maximum latency (msec) to be added|
|config.request_percentage|50|Percentage of requests which shall get the latency added|
|config.add_header|true|If set to true a header X-Kong-Random-Latency will be added with either the value of the added latency or none if random generator has chosen not to add a latency (see also config.request_percentage)|

## Example
````
> http :8001/services/httpbin/plugins name=random-latency 

HTTP/1.1 201 Created
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Thu, 04 Apr 2019 15:18:38 GMT
Server: kong/0.13.1
Transfer-Encoding: chunked

{
    "config": {
        "add_header": true,
        "maximum_latency_msec": 1000,
        "minimum_latency_msec": 0,
        "request_percentage": 50
    },
    "created_at": 1554391119000,
    "enabled": true,
    "id": "2dac1e11-6ec5-4609-ac2a-0591804ca785",
    "name": "random-latency",
    "service_id": "3a0c40f8-7c8d-4441-b0b3-de9836c4e841"
}
````
Response if random generator has decided to add latency:
`````
> http :8000/latency

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Encoding: gzip
Content-Length: 241
Content-Type: application/json
Date: Thu, 04 Apr 2019 15:21:52 GMT
Server: nginx
Via: kong/0.13.1
X-Kong-Proxy-Latency: 90
X-Kong-Random-Latency: 89
X-Kong-Upstream-Latency: 227

(BODY OF RESPONSE)
`````
Response if random generator decided not to add latency (see "none" in header)
`````
> http :8000/latency

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Encoding: gzip
Content-Length: 241
Content-Type: application/json
Date: Thu, 04 Apr 2019 15:23:53 GMT
Server: nginx
Via: kong/0.13.1
X-Kong-Proxy-Latency: 1
X-Kong-Random-Latency: none
X-Kong-Upstream-Latency: 213

(BODY OF RESPONSE)
`````
