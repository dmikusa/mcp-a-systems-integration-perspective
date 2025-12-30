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
</style>

<!-- 
_class: titlepage
_footer: Photo by <a href="https://unsplash.com/@omilaev?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Igor Omilaev</a> on <a href="https://unsplash.com/photos/two-hands-touching-each-other-in-front-of-a-pink-background-gVQLAbGVB6Q?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
_paginate: false
-->
![bg left:40%](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/igor-omilaev-gVQLAbGVB6Q-unsplash.jpg)

# Model Context Protocol: A Systems Integration Perspective

<!-- 
Welcome! This is my session. Let's get started!
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

![drop-shadow width:10em](https://www.7signal.com/hubfs/7SIGNAL-brand-guidelines-logo.png)
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

![drop-shadow height:12em](https://raw.githubusercontent.com/dmikusa/mcp-a-systems-integration-perspective/refs/heads/main/slides/img/qr-code.png)

</div>
<div style="text-align: center; padding-top: 0.5em;">

[https://github.com/dmikusa/mcp-a-systems-integration-perspective](https://github.com/dmikusa/mcp-a-systems-integration-perspective)

</div>

<!--
Slides are available at the link above.
-->

---

# Why are we here today?

<!--
I wrote a remote MCP server for work & there were a number of challenges to doing that. This talk is a chance to share my learnings and to help steer folks in a direction that saves them time and tears.
-->

---

---

<style scoped>
img {
    padding-top: 1.5em;
    height: 300px;
    width: 300px;
}
</style>

# Questions?

<div class="only-img">

:thinking:

</div>
