# vim google translater

**vim baidu translater** 是通过爬虫访问百度翻译网页版提供vim内翻译功能的插件

**该插件通过修改vim插件 [ianva/vim-youdao-translater](https://github.com/ianva/vim-youdao-translater) 得到**

**核心爬虫代码 [通过爬虫实现百度在线翻译](https://blog.csdn.net/blues_f/article/details/79319461)**

## 安装

### 普通安装:
把 `bt.vim` 文件拷贝到 `~/.vim/plugin` 目录下，就可以用了。


### Bundle安装：
如果装有 Bundle 可以 :

1. 修改.vimrc

   ```
   Bundle 'ghoskno/vim-baidu-translate'
   ```

2. ```
   :BundleInstall
   ```




###  其他
添加 `~/.vimrc` 文件：

```vim
vnoremap <silent> <C-T> :<C-u>GGv<CR>
nnoremap <silent> <C-T> :<C-u>GGc<CR>
noremap <leader>ct :<C-u>GGi<CR>
```

## 如何使用

在普通模式下，按 `<C-T>`， 会翻译当前光标下的单词；

在 `visual` 模式下选中单词或语句，按 `<C-T>`，会翻译选择的单词或语句；

点击`<leader>ct`键可以在命令行输入要翻译的单词或语句；

译文将会在编辑器底部的命令栏显示。


