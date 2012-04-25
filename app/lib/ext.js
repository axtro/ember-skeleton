var get = Ember.get;

Ember.View.reopen({
  templateForName: function(name, type) {
    if (!name) { return; }

    var templates = get(this, 'templates'),
        template = get(templates, name);

    if (!template) {
      template = minispade.require('ember-skeleton/~templates/' + name);
      if (!template) {
        this._super(name, type);
      }
    }

    return template;
  }
});
