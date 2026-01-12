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
Who am I? I work at 7SIGNAL, a leader in WiFi optimization. In a nutshell, we write performance monitoring software that helps make your WiFi awesome.

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
Before we get into them, if you're interested, he's a link to the slides.
-->

---

# What's MCP?

<h2 style="margin-left: 10em">Model Context Protocol</h2>

<div class="only-img big-div" style="margin-top: -3em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/mcp.png)

</div>

<!--
Quick Survey:
1. Put your hands up if you've heard of MCP?
2. Keep them up if you've used an MCP server?
3. Keep them up if you've created an MCP server?
4. Keep them up if you're a contributor to the MCP spec?

- A standard for connecting AI applications to remote systems

- Two types, local and remote. 

- Local is great and has some uses cases in particular around giving access to things on your local computer. 
  
  Like files, or the shell. Often seen with development tools. There are different goals and concerns with a local MCP server and we’re not going to talk about that today.

- Remote MCP servers are typically what a business is going to produce, because business have have services and remote MCP is the way to expose those services to AIs that your customers can use.
  
That’s the focus of today’s talk.
-->

---

# What's the Business Value?

<div class="only-img">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/business-value.jpg)

</div>

<!--
- Similar to any API, it exposes your data to others

- Exposes your data to agents & LLMs, like Claude & ChatGPT

- Empowers those agents to have access to data not baked into the models

- For example, let's say we have a SaaS service that sells widgets. We can expose the widget sales data, and users can then dig through that data using Claude or ChatGPT. "Hey Claude, tell me about the sales for Q4.".

- This is powerful because all you need to build is the MCP server to expose the data. You're not building any chat bots, or agents or paying for expensive LLM calls, yet your users get all the benefits of having access to your SaaS via AI.
-->

---

<div class="only-img">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/why-do-we-need-mcp.jpg)

</div>

<!--
Why do we need MCP? What properties does it have that are valuable?

- Claude & ChatGPT.
  
  It is built to work with AI/LLM chat apps like Claude & ChatGPT. It compliments their needs.

- It provides a session. 
  
  AI/LLM chat apps and agents typically consist of a long running session. For example, a chat conversation can go on for hours or days. An agent may go off and do some task that takes minutes or hours to finish. MCP provides the concept of a session as well.
  
  At the same time, MCP doesn't have to be stateful. Stateful often means difficult to scale. There is a stateless option which can scale better, but but sacrifices some features, like elicitation, which require state.

- Helps with context size. 
  
  An early pattern that emerged for interacting with AI/LLMs is RAG, retrieval augmented generation, where you fetch a bunch of stuff you think might be helpful and stuff that into the context with your question to the AI/LLM. This has limits though because you don’t know what the AI/LLM will want or need and the context has a finite size. 
  
  With MCP, we can flip this around. We tell the AI/LLM what’s available and it can tell us what would be helpful. Only sending what’s requested by the AI/LLM reduces context size.

  This isn't a panacea though, if you return a huge chunk of JSON from an MCP tool call, you'll just as quickly blow up the context.

- Discoverable. 
  
  To allow the AI/LLM to request data from us, we need to have metadata describing what's available and we need to be able to dynamically fetch that data. 
  
  For example, we register the MCP server with an AI/LLM, and it fetches metadata that tells it there is information available about books, authors, and tags. We may then ask it a question about those things, and the AI/LLM will request the data it needs to answer your question. That could be fetching a specific book to give you a summary, or fetching all of the books in a specific category to help you find a new books you'd like.

- MCP is a specification, so you get better interoperability than you otherwise would.
  
  Take this with a grain of salt though, at least at this point in time, because while there is a specification not every server/client implements the full specification. There's a [compatibility list available](https://modelcontextprotocol.info/docs/clients/).

  The specification is also evolving rapidly!
-->

---

# Why not Rest and Open API?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/rest-openapi-mcp.jpg)

</div>

<!--
Let's review the important properties of MCP & compare them.

1. Claude/ChatGPT support. No, not natively.
2. It provides a session. Not with OpenAPI
3. Context Size. Both.
4. Discoverability. Both.
5. Specification. Both.
6. Different audiences. Possible, but would require two Open API specs.

As you can see, there is some overlap.

The big win for MCP is compatibility with agents, especially if you're trying to integrate with Claude & ChatGPT. You are simply limited by the integrations they support.

If you have a custom agent. You might be able to get away with using a REST api, since you're coding the agent. But if you're using an agent library, like AWS AgentCore for example, you again are limited to what's supported, which is very likely to be MCP.

Aside from that, you might also just want separate APIs. You've likely built your REST/OpenAPI endpoints with certain targets in mind (humans, UIs, apps, etc...), but since AI/LLMs are new, it's possible they were not included in the design and exposing an MCP service allows you to adjust your API to perhaps fit better for the AI/LLM target.

MCP isn't the only protocol designed to facilitate better interactions with specific clients, gRPC and GraphQL are similar in that regard.
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
-->

---

# Systems Integration All the Way Down

<div class="only-img" style="margin-top: -1em; margin-left: 5em; width: 28em;">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/rube-goldberg.jpeg)

</div>

<!--
This is why I feel that, at it's core, remote MCP is really just a systems integration problem. It's just one more client to support, one more client to integrate with your existing systems.
-->

---

# Patterns for Building Remote MCP Servers

<div class="only-img">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/blue-pill-red-pill.png)

</div>

<!--
When building your remote MCP server, there are two really two strategies.

1. Do you have an existing API? If so, then wrap it for MCP and create a facade. In other words, your MCP server becomes a gateway and it will expose a subset of your API as tool calls, resources, etc... 
   
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
Good news! All the deployment patterns you already use will work just fine for MCP.

- How are you hosting services now? Kubernetes, AWS ECS, Google Cloud Run, Heroku, ...
  
  It's going to work just fine.

- Ancillary products like load balancers and application firewalls, they should all work fine too. 
  
  A remote MCP server is just an API using HTTPS for transport. 
  
  Even if you use the SSE mode, which I don't recommended at this point in time, it's still just HTTPS. All the normal things you're doing to protect your services will likely work with MCP.

- The cloud vendors do have offerings, like AWS AgentCore, where they wil run your MCP services. 
  
  I don't see the value though. If you have an existing playbook for how you deploy HTTP-based services, stick with that. Using these MCP-specific services is just going to unnecessarily tie you to that vendor, but also because, at the time I write this, these are new offerings which might experience growing pains. If you use these services, you will be subject to those pains as the vendor evolves their offering (downtime, functionality limits, things changing in the UI, poor Terraform support, etc...).
-->

---

# Demo

<!--
- Explain the demo

- Show demo code

- Show integration with Claude Desktop
-->

---

# Authentication & Authorization

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/bots.jpg)

</div>

<!--
The minute you make your service public, bots and attackers will be probing it.

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
- If you've secured other APIs with OAuth2, securing your MCP service will be very similar. 80% of what you do for your other APIs will be the same for MCP.

- Just like your other APIs, your MCP service is considered a resource server.
  
  This means that it needs to take the user's token, probably a JWT token, and verify it. From there, your app can use the information in the token to identify the user and make decisions about what the user can access.

- What's even better is that this will typically be handled by the framework you're using, automatically. 
  
  FastMCP, which is based on FastAPI, will do this. So does Spring AI, through Spring Security.
  
  If for some reason your framework of choice doesn't handle this out-of-the-box, then you want to look for a library or extension to provides this functionality. The requirements of a resource server are not extremely difficult to implement, but friends don't let friends reimplement security critical code, so if there is a trusted option available, use it.
-->

---

# What's different?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/senior-chang-squinting.jpg)

</div>

<!--
- Primarily, the OAuth2 client.
  
  For a REST API, the client is going to be your SPA app or your Mobile App, or possibly some scripts running using a client credentials grant.
  
  These are all things you control, and you would typically define each of these clients for each of these services statically in your IDP.

- With MCP, it's different. Your client is unknown. It's an MCP client or agent that you don't control. It may be running on a server or laptop that you don't control either. For example, Claude and ChatGPT, but it could also be an agent that your a user or customer has created.

- To simplify access, the MCP spec authors originally recommended the use of an OAuth2 extension called Dynamic Client Registration, which is [RFC-7591](https://www.rfc-editor.org/rfc/rfc7591).
-->

---

# Dynamic Client Registration (RFC-7591)

<div class="only-img" style="margin-top: -1em">

![height:13em width:26em](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/dog-on-fire.jpg)

</div>

<!--
- What is DCR?
  
  Well, in a nutshell it's simple. DCR requires your IDP to provide an additional endpoint for registering OAuth2 clients dynamically.
  
  A potential client app can send a request to this endpoint which creates a new OAuth2 client within your IDP. The client app can then uses the returned OAuth2 client information just like statically registered OAuth2 client in your IDP.

- Dynamic Client Registration isn't new or specific to MCP. It existed before MCP, but wasn't very popular or used often.

- Having DCR included with MCP has brought a lot of attention to DCR, and unfortunately, I think what has been found is that it doesn't work very well.
-->

---

# Why DCR is not the answer?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/dcr-bad.jpg)

</div>

<!--
The main challenges with supporting DCR:

1. Not all IDPs implement DCR. The ones that do, don't necessarily implement it well.

2. If your IDP doesn't implement it, the workarounds are not great. You basically run your own IDP or a IDP proxy (it will implement DCR and then proxy other OAuth2 requests to your actual IDP).
   
   Both are an avenue for [security problems](https://modelcontextprotocol.io/specification/2025-11-25/basic/security_best_practices#confused-deputy-problem). After all, you use OAuth2 an IDP because you don't want to have to implement this stuff.

As for DCR itself, there are two main problems:

1. There are very few ways to restrict who can create clients.
   
   This is because you do not know who the person is that's creating the client.
   
   You can't trust any of the information they provide, so the only strategies are basic ones like rate limit by IP address, and using allow-lists for properties like scopes and the redirect_url that are requested for the client. This is if your IDP even supports applying limitations.

2. You need to store client state.
   
   If your IDP stores this information on the server side, that is a cost you'll need to manage. It's a small amount of data, but don't overlook this, it can add up.
   
Combine these two issues and it means you're susceptible to DoS attacks, with very few mitigations (IP rate limits).
   
If that's not bad enough, once a client is created, there's virtually no want to clean them up. DoS attacks aside, you still need to eventually clean up legitimately created clients. There's just no good way to do this though.
   
If your IDP supports it, you might be able to look at the last used date, but even then, it's a risk to delete clients. There's no way to know if someone might legitimately try using the client at some future point.

This is compounded further by clients like Claude that do not handle their client being deleted well (at least this was the behavior the last time I checked in late 2025).
-->

---

# Client ID Metadata Documents (CIMD)

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/take-my-money.jpg)

</div>

<!--
- Fortunately, there is something better: [Client ID Metadata Documents (CIMD)](https://client.dev/).

- This is very new, added to the 2025-11-25 version of the MCP specification. It is a better way to manage dynamic clients because it puts the burden on the client, not the server.

- In a nutshell, the client must create a metadata document and host it somewhere accessible to the server via HTTPS. The document identifies the client. The client then uses a URL to the metadata document as its client_id when talking to the IDP. The IDP can then fetch the client's metadata and validate it (including the TLS information).
-->

---

# CIMD FTW?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/cimd-support.jpg)

</div>

<!--
I wish I had better news, but at this point in early Jan 2026, the major LLMs and Agents do not yet support CIMD.

I wish I could sit here and tell you to just skip over DCR entirely, but since CIMD support isn't widely available, at least if you're targeting the major LLMs and Agents, [Claude](https://support.claude.com/en/articles/11503834-building-custom-connectors-via-remote-mcp-servers) and ChatGPT in early 2026, you may still need to support DCR.
-->

---

# What to do then?

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/dcr-bad-time.jpg)

</div>

<!--
1. Use DCR only as a last resort.

2. Look at your needs & the clients you must support. Because "it depends".

If not DCR and not CIMD then ...

1. Support static client configuration. Both Claude & ChatGPT support using statically configured clients when registering an MCP server. Depending on your audience, this may be sufficient. For example, if you have an internal audience and you can work with them to set things up. This could get difficult if you are trying to allow customers or a wide audience to register as each person would need their own client (do not share clients).

2. Lean on your IDP. If you are lucky, and your IDP has a good implementation of DCR, then you're all set.

   The key points:

   1. Have a way to control what a user can dynamically register as a client
   2. Have a way to clean up clients automatically.
   
   If a user can register a client with any scopes or if a user can register a client with any redirect_uri, that's very bad. If you don't have a way to clean up clients, that's bad too.

3. DCR Proxy. There are options to use a proxy to add on DCR support, either in your MCP server or as a standalone service. 
   
   I would not recommend this. I did this with FastMCP, and through no fault of theirs, it creates problems. FastMCP nails the client registration controls and provides ways to mitigate the client storage issue, but what you effectively end up with is a second IDP, complete with different tokens signed by a different set of keys that everything now needs to trust.
   
   For us, this was too much effort and a deal breaker. 

Lastly, keep monitoring the situation. Things are evolving rapidly.

1. Watch out for Claude & ChatGPT (or your target LLM/Agents) supporting the "2025-11-25" version of the MCP spec and CIMD specifically.
2. Check with your IDP to see if it supports CIMD or if that is on the roadmap.
-->

---

# Summary

<div class="only-img" style="margin-top: -1em">

![](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/dev-team-priorities.jpg)

</div>

<!--
In 2025, I wrote a remote MCP server for work. It was hard. It shouldn't have been though.

Reflecting on the experience, it was hard for two main reasons:

1. MCP isn't a finished protocol. MCP had *three* spec releases in 2025 alone. It's a moving target. This creates all kinds of issues for a business that wants to support MCP.

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
