describe 'Cocos2d-JS class, property and method autocompletions', ->
  [editor, provider] = []

  getCompletions = ->
    cursor = editor.getLastCursor()
    start = cursor.getBeginningOfCurrentWordBufferPosition()
    end = cursor.getBufferPosition()
    prefix = editor.getTextInRange([start, end])
    request =
      editor: editor
      bufferPosition: end
      scopeDescriptor: cursor.getScopeDescriptor()
      prefix: prefix
    provider.getSuggestions(request)

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('autocomplete-cocos2d-js')
    runs ->
      provider = atom.packages.getActivePackage('autocomplete-cocos2d-js')
        .mainModule.getProvider()
    waitsFor -> Object.keys(provider.completions).length > 0
    waitsForPromise -> atom.workspace.open('test.js')
    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setText('test')
      editor.setCursorBufferPosition([0, Infinity])

  it 'includes the classes of Cocos2d-JS', ->
    expect(getCompletions()).toContain {type:'class', text:'Node'}
    expect(getCompletions()).toContain {type:'class', text:'Sprite'}
    expect(getCompletions()).toContain {type:'class', text:'LabelTTF'}
    expect(getCompletions()).toContain {type:'class', text:'TextFieldTTF'}

  it 'includes the properties of Cocos2d-JS', ->
    expect(getCompletions()).toContain {type:'property', text:'ALIGN_LEFT'}
    expect(getCompletions()).toContain {type:'property', text:'FOCUS'}
    expect(getCompletions()).toContain {type:'property', text:'anchorX'}
    expect(getCompletions()).toContain {type:'property', text:'onStart'}

  it 'includes the methods of Cocos2d-JS', ->
    expect(getCompletions()).toContain {type:'method', text:'ctor'}
    expect(getCompletions()).toContain {type:'method', text:'addChild'}
    expect(getCompletions()).toContain {type:'method', text:'clear'}
    expect(getCompletions()).toContain {type:'method', text:'getContourData'}
