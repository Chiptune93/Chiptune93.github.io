---
layout: post
title: VS Code - code snippet $ escape ( dollar sign )
description: >
  [VS Code] code snippet $ escape ( dollar sign )

hide_last_modified: true
categories: [IDE]
tags: [vscode, snippet, escape]
---

- Table of Contents
{:toc .large-only}

VS Code snippet 에서 $ 표시가 필요할 때.

from

```
"mySnippet": {
	"prefix" : [
    	"test"
    ],
    "body":[
    	"$('body').html();",
        "\t\n",
        "\t"
    ]
}
```

To

```
"mySnippet": {
	"prefix" : [
    	"test"
    ],
    "body":[
    	"\\$('body').html();",
        "\t\n",
        "\t"
    ]
}
```

> $ 앞에 \\ 를 붙인다.
