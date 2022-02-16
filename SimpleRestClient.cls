public virtual class SimpleRestClient {

private class SimpleRestClientException extends Exception{}

    public string namedCredential {get; private set;}
    public Map<String,String> headers {get; private set;}
    public String endpoint {get; private set;}
    public String method {get; private set;}
    public String body {get; private set;} 

    public SimpleRestClient(){
        this.headers = new Map<String, String>();
    }//create empty class

    public SimpleRestClient(String namedCredential, String endpoint, String method, String body) {
        this.namedCredential = namedCredential;
        this.method = method;
        this.endpoint = endpoint;
        this.body = body;
    }

    public void setNamedCredential(String namedCredential){
        if(this.namedCredential == null){
            this.namedCredential = namedCredential;
        }else{
            throw new SimpleRestClientException('The named Credential has already been set');
        }
    }

    public void addHeader(String headerKey, String headerValue){
        system.debug(JSON.serializePretty(this));
        this.headers.put(headerKey, headerValue);
    }

    public void setEndpoint(String endpoint){
        if(this.endpoint == null){
            this.endpoint = endpoint;
        }else{
            throw new SimpleRestClientException('The endpoint has already been set');
        }
    }

    public void setMethod(String method){
        if(this.method == null){
            this.method = method;
        }else{
            throw new SimpleRestClientException('The method has already been set');
        }
    }

    public void setBody(String body){
        if(this.body == null){
            this.body = body;
        }else{
            throw new SimpleRestClientException('The body has already been set');
        }
    }

    public HttpResponse send(){
        Http h = new Http();
        HttpRequest request = buildRequest();        
        system.debug(request.getEndpoint());
        system.debug(request.getBody());
        system.debug(request.getHeader('Content-Type'));
        HttpResponse response = h.send(request);
        return response;
    }

    protected HttpRequest buildRequest(){
        HttpRequest request = new HttpRequest();
        request.setMethod(this.method.toUpperCase());
        request.setEndpoint(buildEndpoint());
        for(String header :this.headers.keySet()){
            request.setHeader(header, this.headers.get(header));
        }
        request.setBody(this.body);
        return request;
    }

    protected String buildEndpoint(){
        this.endpoint = (this.namedCredential != null ? 'callout:'+namedCredential : '') + this.endpoint;
        if(String.isBlank(this.endpoint)) throw new SimpleRestClientException('The endpoint can\'t be blank');
        return this.endpoint;
    }

    public String createURLEncodedBody(Map<String, String> mapFormBody){//used for application/x-www-form-urlencoded content-types, could throw and exception checking the header
        if(!String.isBlank(this.body)) throw new SimpleRestClientException('The body needs to be blank');
        this.body = '';//the body will be null and null will be added due to below
        for(String bodyItem :mapFormBody.keySet()){
            this.body += bodyItem+'='+EncodingUtil.urlEncode(mapFormBody.get(bodyItem), 'UTF-8');
        }
        return body;
    }
}
