// Generated by CoffeeScript 1.10.0
(function() {
  var DimDom,
    hasProp = {}.hasOwnProperty;

  DimDom = (function() {
    var ensureArray, findConstructorArgs, isChildren, isObject, isString;

    function DimDom(name, attributes, styles, children) {
      var namespace, ref;
      ref = findConstructorArgs(name, attributes, styles, children), namespace = ref[0], name = ref[1], attributes = ref[2], styles = ref[3], children = ref[4];
      Object.defineProperties(this, {
        namespace: {
          value: namespace
        },
        name: {
          value: name
        },
        attributes: {
          value: attributes
        },
        styles: {
          value: styles
        },
        children: {
          value: children
        }
      });
    }

    DimDom.prototype.create = function(document) {
      var child, i, len, name, node, ref, ref1, ref2, value;
      node = this.namespace != null ? document.createElementNS(this.namespace, this.name) : document.createElement(this.name);
      ref = this.attributes;
      for (name in ref) {
        if (!hasProp.call(ref, name)) continue;
        value = ref[name];
        if (value != null) {
          node.setAttribute(name, value);
        }
      }
      ref1 = this.styles;
      for (name in ref1) {
        if (!hasProp.call(ref1, name)) continue;
        value = ref1[name];
        if (value != null) {
          node.style[name] = value;
        }
      }
      ref2 = this.children;
      for (i = 0, len = ref2.length; i < len; i++) {
        child = ref2[i];
        if (child instanceof DimDom) {
          child.appendTo(node);
        } else {
          if (!(child instanceof Node)) {
            child = document.createTextNode(child);
          }
          node.appendChild(child);
        }
      }
      return node;
    };

    DimDom.prototype.appendTo = function(node) {
      var child;
      child = this.create(node.ownerDocument);
      node.appendChild(child);
      return this;
    };

    findConstructorArgs = function(name, attributes, styles, children) {
      var namespace, ref, ref1, ref2, ref3;
      if (Array.isArray(name)) {
        ref = name, namespace = ref[0], name = ref[1];
      }
      if (!isString(name)) {
        throw new TypeError("DimDom name must be a string, not \"" + (typeof name) + "\"");
      }
      if ((namespace != null) && !isString(namespace)) {
        throw new TypeError("DimDom namespace must be a string, not \"" + (typeof namespace) + "\"");
      }
      if (isChildren(attributes)) {
        ref1 = [{}, {}, attributes], attributes = ref1[0], styles = ref1[1], children = ref1[2];
      } else if (isChildren(styles)) {
        ref3 = [(ref2 = attributes['styles']) != null ? ref2 : {}, styles], styles = ref3[0], children = ref3[1];
        delete attributes['styles'];
      }
      children = ensureArray(children);
      return [namespace, name, attributes, styles, children];
    };

    isString = function(val) {
      return (typeof val === 'string') || (val instanceof String);
    };

    isObject = function(val) {
      return (val != null) && (typeof val === 'object') && !Array.isArray(val);
    };

    isChildren = function(val) {
      return (val instanceof DimDom) || (val instanceof Node) || !isObject(val);
    };

    ensureArray = function(val) {
      if (val == null) {
        return [];
      } else if (Array.isArray(val)) {
        return val;
      } else {
        return [val];
      }
    };

    return DimDom;

  })();

}).call(this);
