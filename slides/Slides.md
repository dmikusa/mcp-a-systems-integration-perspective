---
title       : "Model Context Protocol: A Systems Integration Perspective"
author      : Daniel Mikusa
description : "Model Context Protocol (MCP) is everywhere these days. It’s often presented as a revolutionary new paradigm that’s going to replace everything, but at its core, it's simply another interface for fetching data and performing remote actions—like REST or RPC. This session reframes MCP through a systems integration lens, demonstrating how to integrate it with your existing systems rather than replacing them entirely."
keywords    : ai, mcp, python
marp        : true
theme       : jobs
paginate    : true
---
<!-- markdownlint-disable MD013 MD025 MD033 -->

<style>
.columns {
    display: flex;
}
.column {
    flex: 1;
}
.center {
    display: block;
    margin-left: auto;
    margin-right: auto;
}
.center-img img {
    display: block;
    margin-left: auto;
    margin-right: auto;
}
.only-img img {
    margin-top: 1.5em;
    display: block;
    margin-left: auto;
    margin-right: auto;
}
.big-div img {
    padding-top: 1.5em;
    height: 300px;
    width: 300px;
}
</style>

<!-- 
_class: titlepage
_footer: Photo by <a href="https://unsplash.com/@omilaev?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Igor Omilaev</a> on <a href="https://unsplash.com/photos/two-hands-touching-each-other-in-front-of-a-pink-background-gVQLAbGVB6Q?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
_paginate: false
-->
![bg left:40%](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/igor-omilaev-gVQLAbGVB6Q-unsplash.jpg)

# Model Context Protocol: A Systems Integration Perspective

<!-- 
Welcome! This is my session on MCP. Let's get started!
-->

---

<div class="columns">
<div class="column">

## Daniel Mikusa

- Lead Software Engineer @ 7SIGNAL, Inc
- Paketo Steering Committee Member
- Cloud-Native Buildpacks Maintainer

### Contact Me

- <small>dan@mikusa.com</small>
- <small>https://github.com/dmikusa</small>
- <small>https://www.mikusa.com</small>

</div>
<div class="column center-img">

![drop-shadow width:10em](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/7SIGNAL-LOGO-RGB-CLR-LGHT-BG.svg)
![drop-shadow width:10em](https://paketo.io/v2/images/logo-paketo-dark.svg)
![drop-shadow width:10em](https://buildpacks.io/images/buildpacks-logo.svg)

</div>
</div>

<!--
Who am I? I work at 7SIGNAL, a leader in WiFi optimization. In a nutshell, we write software that helps you to make your WiFi rock.

I also help with a couple of OSS projects, Cloud-Native Buildpacks and Paketo Buildpacks. Both, great tools for building your container images.

While I'm not covering WiFi or buildpacks in this talk, if you're curious feel free to come chat after the session.
-->

---

# Slides

<div class="center-img">

![drop-shadow height:12em](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/slides-qrcode.png)

</div>
<div style="text-align: center; padding-top: 0.5em;">

[https://github.com/dmikusa/mcp-a-systems-integration-perspective](https://github.com/dmikusa/mcp-a-systems-integration-perspective)

</div>

<!--
Slides are available at the link above.
-->

---

# What's MCP?

<h2 style="margin-left: 10em">Model Context Protocol</h2>

<div class="only-img big-div" style="margin-top: -3em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/mcp.png)

</div>

<!--
- A standard for connecting AI applications to remote systems
- Two types, local and remote. 
- Local is great and has some uses cases in particular around giving access to things on your local computer. Like files, or the shell. Often seen with development tools. There are different goals and concerns with a local MCP server and we’re not going to talk about that today.
- Remote MCP servers are typically what a business is going to produce, because business have have services and remote MCP is the way to expose those services to AIs that your customers can use. That’s the focus of today’s talk.
-->

---

<div class="only-img">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/why-do-we-need-mcp.jpg)

</div>

<!--
Why do we need MCP? What properties does it have that are valuable?

- It is built to work with AI/LLM chat apps like Claude & ChatGPT. It compliments their needs.
- Session based. AI/LLM chat apps and agents may have a long running sessions. For example, a chat or an agent that is doing some analysis. MCP doesn't have to be session based, there's a stateless option, but it does have some features which rely on there being a session.
- Helps with context size. An early pattern that emerged for interacting with AI/LLMs is RAG, retrieval augmented generation, where you fetch a bunch of stuff you think might be helpful and stuff that into the context with your question to the AI/LLM. This has limits though because you don’t know what the AI/LLM will want or need and the context has a finite size. With MCP, we can flip this around. We tell the AI/LLM what’s available and it can tell us what would be helpful. Only sending what’s requested by the AI/LLM reduces context size.
- Discoverable. To allow the AI/LLM to request data from us, we need to have metadata describing what's available and we need to be able to dynamically fetch that data. For example, we register the MCP server with an AI/LLM, and it fetches metadata that tells it there is information available about books, authors, and tags. We may then ask it a question about those things, and the AI/LLM will request the data it needs to answer your question. That could be fetching a specific book to give you a summary, or fetching all of the books in a specific category to help you find a new books you'd like.
- MCP is a specification, so you get better interoperability than you otherwise wood. Take this with a grain of salt though, at least at this point in time, because while there is a specification not every server/client implements the full specification. There's a [compatibility list available](https://modelcontextprotocol.info/docs/clients/).
-->

---

# Why not Rest and Open API?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/rest-openapi-mcp.jpg)

</div>

<!--
- Well, you certainly could use OpenAPI it gives you a standard set of metadata, and a way to find resources that are available so it’s discoverable. 
- The big thing is that it needs agent buy in. The consuming client would need to agree to access your API via rest and OpenAPI specs. If you’re writing the agent, that’s a decision you can make. If you’re trying to integrate with Claude, who made MCP, it’s unlikely they would do that, and you absolutely need their buy in to make things work.
- The AI/LLM is able to make decisions about what to execute based on the metadata, but it doesn’t perform actual tool calls or fetch additional information. The MCP client, often an agent, does that. That means the agent needs to understand the protocol and how to make those requests.
- You might also want separate APIs. You've likely built your REST/OpenAPI endpoints with certain targets in mind (humans, UIs, apps, etc...), but since AI/LLMs are new, it's possible they were not included in the design and exposing an MCP service allows you to adjust your API to perhaps fit better for the AI/LLM target. MCP isn't the only protocol designed to facilitate better interactions with specific clients, gRPC and GraphQL are similar in that regard.
- At the end of the day, the main reason you shouldn't do this is simply because clients like Claude and ChatGPT just won't support this as a first class option. If you want them to connect to your APIs, then MCP is what you need use. If you’re only making custom agents, you could technically write them to any API. You would write them to use OpenAPI/REST. You may lose out on some advantages certain client/agent framework/libraries provide though, because again, they'll be targeting MCP. For example, AWS AgentCore supports MCP out-of-the-box.
-->

---

# So MCP Everywhere?

<div class="only-img">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/all-your-bases.jpg)

</div>

<!--
Do you replace your REST/OpenAPI services with it?

No! It’s not generally useful to say a web or mobile client, but is useful to expose your services to AI/LLMs and Agents though. So, I'm sorry to say, but you need both.
-->

---

# Trust Your Instincts

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/glasses-api-mcp.jpg)

</div>

<!--
This is not a new Problem!

As API designers, we have to support may different clients, and MCP is no different. Every client has different capabilities and needs. Not one protocol or approach is going to be perfect for all of them.

REST is great for a general purpose API, for browser or mobile clients, but other clients might work better with gRPC or GraphQL or MQTT. You're just building different interfaces for different clients, and MCP is the interface to use for integrating with LLMs and Agents.

This is why, at it's core, remote MCP is really just a systems integration problem. It's just one more client to support, one more client to integrate with your existing systems.
-->

---

# Patterns for Building Remote MCP Servers

<div class="only-img">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/blue-pill-red-pill.png)

</div>

<!--
When building your remote MCP server, there are two really two strategies.

1. Do you have an existing API? If so, then wrap it for MCP. In other words, your MCP server becomes a gateway and it will expose a subset of your API as tool calls, resources, etc... 
   
   This is such a common pattern, that there are tools to take an OpenAPI spec and turn that into an MCP server with almost no code (eg. FastMCP). This does require that your Open API spec have detail and documentation to work well though, since that is what will be exposed as your MCP metadata.

2. No API? Ok. You *can* have your remote MCP server make calls to a database (or read your Excel files), but think long and hard about doing that. 
   
   What will you do if you need to support some other client that's not an Agent? MCP won't be a good choice and you'll be stuck. If instead you start by exposing a more general purpose API, like with Rest, JSON, and OpenAPI; then you'll be in a much better position when you eventually get a request to support more clients.
-->

---

# Patterns for Deploying Remote MCP Server

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/good-news.jpg)

</div>

<!--
Good news! All the patterns you already use will work just fine for MCP.

- How are you hosting services now? Kubernetes, AWS ECS, Google Cloud Run, Heroku, ... They're going to work just fine.
- Ancillary products like load balancers and application firewalls, they should all work fine too.
- A remote MCP server is just an API using HTTPS for transport. Even if you use the SSE mode, which I don't recommended at this point in time, it's still just HTTPS. All the normal things you're doing to protect your services will likely work with MCP.
- The cloud vendors do have offerings, like AWS AgentCore, where they wil run your MCP services. I don't see the value though. If you have an existing playbook for how you deploy HTTP-based services, stick with that. Using these MCP-specific services is just going to unnecessarily tie you to that vendor, but also because, at the time I write this, these are new offerings which might experience growing pains. If you use these services, you will be subject to those pains as the vendor evolves their offering (downtime, functionality limits, things changing in the UI, poor Terraform support, etc...).
-->

---

# Demo

---

# Authentication & Authorization

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/bots.jpg)

</div>

<!--
The minute you host your service, things will be probing it.

- Just like most APIs, most MCP services are going to require authentication. Unless you're hosting public information, like with the demo MCP server.
- Just like when building an API, for MCP, we are going to reach for OAuth2 & OIDC to secure our service.
- Technically, you do not need to use OAuth2. MCP allows for using an API key, but it is strongly recommended that you use OAuth2, just like with an API, it provides the most control for you and the best experience for user.
-->

---

# What's the same?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/spidermans.jpg)

</div>

<!--
- Fortunately, if you've secured other APIs with OAuth2, securing your MCP service will be very similar. 80% of what you do for your other APIs will be the same for MCP.
- Just like your other APIs, your MCP service is considered a resource server. This means that it needs to take the user's token, probably a JWT token, and verify it. From there, your app can use the information in the token to identify the user and make decisions about what the user can access.
- What's even better is that this will typically be handled by the framework you're using, automatically. 
  
  FastMCP, which is based on FastAPI, will do this. So does Spring AI, through Spring Security. If for some reason your framework of choice doesn't handle this out-of-the-box, then you want to look for a library or extension to provides this functionality. The requirements of a resource server are not extremely difficult to implement, but friends don't let friends reimplement security critical code, so if there is a trusted option available, use it.
-->

---

# What's different?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/senior-chang-squinting.jpg)

</div>

<!--
- Primarily, it's the client. For a REST API, the client is going to be your SPA app or your Mobile App, or possibly some scripts running using a client credentials grant. These are all things you control, and you would typically defined each of these clients for each of these services statically in your IDP.
- With MCP, it's different. Your client is some MCP client/agent. You don't control that client/agent. It might be Claude or ChatGPT or some client/agent that your customer has created.
- To account for this, the MCP spec authors recommend the use of an OAuth2 extension called Dynamic Client Registration, which is [RFC-7591](https://www.rfc-editor.org/rfc/rfc7591).
-->

---

# Dynamic Client Registration (RFC-7591)

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/dog-on-fire.jpg)

</div>

<!--
- What is DCR? Well, in a nutshell, DCR just requires your IDP to provide an additional endpoint. Potential clients can then send a request to that endpoint which creates a new client with the IDP. The client can then uses the returned client information just like any client created by the IDP.
- Dynamic Client Registration isn't new for MCP. It existed before MCP, but wasn't very popular or used much.
- Having DCR included with MCP has brought a lot of attention to DCR, and unfortunately, I think what has been found is that it doesn't work very well.
-->

---

# Why DCR is not the answer?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/dcr-bad.jpg)

</div>

<!--
1. Not all IDPs implement DCR. The ones that do, don't necessarily implement it well.
2. If your IDP doesn't implement it, the workarounds are not great. You basically run your own IDP or you need to run a proxy that implements DCR and then proxies other OAuth2 requests to your actual IDP. This isn't great though. It's an avenue for [more security problems](https://modelcontextprotocol.io/specification/2025-11-25/basic/security_best_practices#confused-deputy-problem).
3. There are very few ways to restrict who can create clients. This is because you do not know who the person is that's creating the client. You can't trust any of the information they provide, so the only strategies are basic ones like rate limit by IP address, and using allow-lists for properties like scopes and the redirect_url that are requested for the client. This is if your IDP even supports applying limitations. Remember how I said not all IDPs implement this spec well, I know of at least one that doesn't support any limitations.
4. After a client is created, there is some state that needs to be stored for this client. If your IDP stores this information on the server side, that is a cost you'll need to manage. Do not overlook this because it is a small amount of data. The trouble with DCR is that you don't know who's making clients, so one person could make a million different clients (accidentally or maliciously). The only defense you have against a DoS is basic rate limiting by IP address. If that's not bad enough, once a client is created, there's virtually no want to clean them up. If your IDP supports it, you might be able to look at the last used date, but even then, it's a risk to delete clients. There's just no way to know if someone might legitimately try using the client at some future point. This is compounded further by clients like Claude that do not handle their client being deleted well (at least this was the behavior the last time I checked in 2025).
-->

---

# Client ID Metadata Documents (CIMD)

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/take-my-money.jpg)

</div>

<!--
- Fortunately, there is something better: [Client ID Metadata Documents (CIMD)](https://client.dev/).
- This is very new, added to the 2025-11-25 version of the MCP specification. It is a better way to manage dynamic clients because it puts the burden on the client, not the server.
- In a nutshell, the client must create a metadata document and host it somewhere accessible to the server. The document identifies the client. The client then uses a URL to the metadata document as its client_id when talking to the IDP. The IDP can then fetch the client's metadata and validate it.
-->

---

# It's Jan 2026, what should I do?

<!--
At this point, in Jan 2026, I would not recommend supporting DCR. It's a headache that you want to avoid. You need to check if your IDP, MCP framework and clients support CIMD though. If they do, by all means use it. If CIMD isn't an option, then I would suggest using static client registration. It's a bit more work to set up a remote MCP connection in an MCP client this way, but it allows you to control who's registering clients and put polices in place to effectively manage them (i.e. that customer left, delete their client). Additionally, many of the big clients like Claude and Microsoft Co-Pilot are supporting static registration.

Only implement DCR in a new service as a last resort, like if you have a particularly stubborn client that doesn't support static client registration.
-->

---

# Summary

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/dev-team-priorities.jpg)

</div>

<!--
In 2025, I wrote a remote MCP server for work. It was hard. It shouldn't have been though.

Reflecting on the experience, it was hard for two main reasons:

1. MCP isn't a finished protocol. MCP had *three* spec releases in 2025 alone. It's a moving target. This creates all kinds of issues.
- Projects and vendors that implement the spec are keeping up at different paces. They don't all implement the full spec the day it's released, so things might be missing or implemented at later dates.
- Implementations from all the vendors are brand new, so none of them are really battle tested, which means you will hit bugs. Find your framework's Issue Tracker and be ready to report issues. For larger providers, cross your fingers and hope the fix the issue quick.
- This isn't all bad though. It also means everything is also improving at a rapid pace. The spec is addressing pain points multiple times a year, and vendors are fixing bugs faster than I can ever remember seeing. While I was building out our MCP server, I hit a few issues with FastMCP and the project had fixes in just a day or two. Similarly, when I was doing our Microsoft Co-pilot integration, when I'd hit a bug, I'd just put down that story for a week, and when I came back to the story the issue would be resolved.

2. Authentication with MCP is a challenge. OAuth2/OIDC can itself be a big hurdle, in fact, I've got a whole separate talk on OAuth2/OIDC. When you layer on things like DCR, it gets worse. Fortunately, the spec improvements are addressing Authentication. You will always need to get over the OAuth2/OIDC hurdle, but CIMD replacing DCR is a huge benefit to developers and operators of MCP servers.
-->

---

# Feedback

<div class="only-img big-div" style="margin-top: -85px">

![drop-shadow width:12em height:12em](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/model-context-protocol-a-systems-integration-pers_mikusa_1024007_feedback-code.png)

<div style="text-align: center; padding-top: 0.5em;">

[https://sfeedback.com/hi4iof](https://sfeedback.com/hi4iof)

</div>

</div>

---

# Questions?

<div class="only-img big-div">

:thinking:

</div>

---

# Slides (again)

<div class="center-img">

![drop-shadow height:12em](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/slides-qrcode.png)

</div>
<div style="text-align: center; padding-top: 0.5em;">

[https://github.com/dmikusa/mcp-a-systems-integration-perspective](https://github.com/dmikusa/mcp-a-systems-integration-perspective)

</div>

<!--
Slides are available at the link above.
-->
