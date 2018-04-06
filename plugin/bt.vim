"Check if py3 is supported
function! s:UsingPython3()
  if has('python3')
    return 1
  endif
  if has('python')
    return 0
  endif
  echo "Error: Required vim compiled with +python/+python3"
  finish
endfunction

let s:using_python3 = s:UsingPython3()
let s:python_until_eof = s:using_python3 ? "python3 << EOF" : "python << EOF"
let s:python_command = s:using_python3 ? "py3 " : "py "

" This function taken from the lh-vim repository
function! s:GetVisualSelection()
    try
        let a_save = @a
        normal! gv"ay
        return @a
    finally
        let @a = a_save
    endtry
endfunction

function! s:GetCursorWord()
    return expand("<cword>")
endfunction

exec s:python_until_eof

# -*- coding: UTF-8 -*-
try:
  import requests
  import json
  import sys
except  ImportError:
  pass

def str_decode(word):
    if sys.version_info >= (3, 0):
        return word
    else:
        return word.decode('utf-8')

class BaiduFanyi:
  def __init__(self,trans_str):
    self.trans_str = trans_str
    self.lang_detect_url = "http://fanyi.baidu.com/langdetect"
    self.trans_url = "http://fanyi.baidu.com/basetrans"
    self.headers = {"User-Agent":"Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Mobile Safari/537.36"}

  def parse_url(self,url,data):
    response = requests.post(url,data=data,headers=self.headers)
    return json.loads(response.content.decode())

  def get_ret(self,dict_response):
    ret = dict_response["trans"][0]["dst"]
    parts_result = []
    if 'symbols' in dict_response["dict"]:
      parts = dict_response["dict"]["symbols"][0]["parts"]
      parts_result = ''.join(('['+item['part'] + ''.join(item["means"])+']') for item in parts)
    return '[target: %s], {smartResults: %s}' % (ret, parts_result) 

  def run(self):
    lang_detect_data = {"query":self.trans_str}
    lang = self.parse_url(self.lang_detect_url,lang_detect_data)["lan"]
    trans_data = {"query":self.trans_str,"from":"zh","to":"en"} if lang== "zh" else \
        {"query":self.trans_str,"from":"en","to":"zh"}
    dict_response = self.parse_url(self.trans_url,trans_data)
    return self.get_ret(dict_response)


def translate_visual_selection(lines):
  try:
    baidu_fanyi = BaiduFanyi(lines.replace('\n', ' '))
    result = baidu_fanyi.run()
  except Exception as e:
    result = 'network err! Please check your network connection.'

  vim.command('echo "' + str_decode(result) + '"')
EOF

function! s:BaiduVisualTranslate()
    exec s:python_command 'translate_visual_selection(vim.eval("<SID>GetVisualSelection()"))'
endfunction

function! s:BaiduCursorTranslate()
    exec s:python_command 'translate_visual_selection(vim.eval("<SID>GetCursorWord()"))'
endfunction

function! s:BaiduEnterTranslate()
    let word = input("Please enter the word: ")
    redraw!
    exec s:python_command 'translate_visual_selection(vim.eval("word"))'
endfunction

command! GGv call <SID>BaiduVisualTranslate()
command! GGc call <SID>BaiduCursorTranslate()
command! GGi call <SID>BaiduEnterTranslate()
