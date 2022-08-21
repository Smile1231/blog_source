---
title: Vue实现Yaml验证组件
hide: false
tags: Vue
categories: Vue
keywords:
  - Vue
  - Yaml
  - 组件
abbrlink: bd30a519
date: 2022-08-21 22:03:49
---

最近用到了`Vue`页面使用`Yaml`编辑器，但是这样的组件也是从来没有接触过的，这边做个记载:

[原文](https://blog.csdn.net/qq_40981137/article/details/105448713)

## 安装必要依赖

1. `npm install codemirrir@5.61.1`
2. `npm installl js-yaml@4.1.0`

## 创建对应的组件

路径为`@/components/YamlEditor/index.vue`

```js
<template>
  <div class="yaml-editor">
    <textarea ref="textarea" />
  </div>
</template>

<script>
import CodeMirror from 'codemirror'
import 'codemirror/addon/lint/lint.css'
import 'codemirror/lib/codemirror.css'
import 'codemirror/theme/monokai.css'
import 'codemirror/mode/yaml/yaml'
import 'codemirror/addon/lint/lint'
import 'codemirror/addon/lint/yaml-lint'

window.jsyaml = require('js-yaml') // 引入js-yaml为codemirror提高语法检查核心支持

export default {
  name: 'YamlEditor',
  // eslint-disable-next-line vue/require-prop-types
  props: ['value'],
  data() {
    return {
      yamlEditor: false
    }
  },
  watch: {
    value(value) {
      const editorValue = this.yamlEditor.getValue()
      if (value !== editorValue) {
        this.yamlEditor.setValue(this.value)
      }
    }
  },
  mounted() {
    this.yamlEditor = CodeMirror.fromTextArea(this.$refs.textarea, {
      lineNumbers: true, // 显示行号
      mode: 'text/x-yaml', // 语法model
      gutters: ['CodeMirror-lint-markers'],  // 语法检查器
      theme: 'monokai', // 编辑器主题
      lint: true // 开启语法检查
    })

    this.yamlEditor.setValue(this.value)
    this.yamlEditor.on('change', (cm) => {
      this.$emit('changed', cm.getValue())
      this.$emit('input', cm.getValue())
    })
  },
  methods: {
    getValue() {
      return this.yamlEditor.getValue()
    }
  }
}
</script>

<style scoped>
.yaml-editor{
  height: 100%;
  position: relative;
}
.yaml-editor >>> .CodeMirror {
  height: auto;
  min-height: 300px;
}
.yaml-editor >>> .CodeMirror-scroll{
  min-height: 300px;
}
.yaml-editor >>> .cm-s-rubyblue span.cm-string {
  color: #F08047;
}
</style>
```
`codemirror`的核心配置如下：
```js
this.yamlEditor = CodeMirror.fromTextArea(this.$refs.textarea, {
    lineNumbers: true, // 显示行号
    mode: 'text/x-yaml', // 语法model
    gutters: ['CodeMirror-lint-markers'],  // 语法检查器
    theme: 'monokai', // 编辑器主题
    lint: true // 开启语法检查
})
```
这里的配置只有几个简单的参数，更多的详细参数配置可以移步[官方文档](https://codemirror.net/doc/manual.html)；如果想让编辑器支持其他语言，可以查看codemirror官方文档的[语法支持](https://codemirror.net/mode/)，这里我个人比较倾向下载`codemirror`源码，可以看到对应语法`demo`源代码，使用不同的语法在本组件中`import`相应的依赖即可。

这边不同的主题: [theme](https://codemirror.net/5/theme/)

## 使用组件

```js
<template>
  <div>
    <div class="editor-container">
      <yaml-editor  v-model="value" />
    </div>
  </div>
</template>

<script>
import YamlEditor from '@/components/YamlEditor/index.vue';

const yamlData = "- hosts: all\n  become: yes\n  become_method: sudo\n  gather_facts: no\n\n  tasks:\n  - name: \"install {{ package_name }}\"\n    package:\n      name: \"{{ package_name }}\"\n      state: \"{{ state | default('present') }}\"";

export default {
  name: 'YamlEditorDemo',
  components: { YamlEditor },
  data() {
    return {
      value: yamlData,
    };
  },
};
</script>
<style scoped>
.editor-container{
  position: relative;
  height: 100%;
}
</style>
```

效果：
{% asset_img 2022-08-21-22-50-44.png %}


