from pathlib import Path
import json
for f in Path('.').glob('*.lua'):
 f.write_text(f.read_text().replace('__More-Asteroids__','__razi-more-asteroids__'))
i=json.loads(Path('info.json').read_text())
i.update(name='razi-more-asteroids',version='0.5.0',title='Razi More Asteroids: K2SO Edition',author="Razi's Realm (based on More Asteroids by spartanlaser32)",factorio_version='2.1',homepage='https://github.com/spartanlaser32/More-Asteroids',description='K2SO-focused More Asteroids fork with guarded crushers, six resource families, and Razi Protocol compatibility.')
i['dependencies']=['base >= 2.1.20','space-age >= 2.1.20','Krastorio2-spaced-out >= 2.0.17','! More-Asteroids','(?) Cerys-Moon-of-Fulgora','(?) planet-muluna','(?) maraxsis']
Path('info.json').write_text(json.dumps(i,indent=2)+'\n')
Path('data.lua').write_text('require("asteroids")\nrequire("recipe")\nrequire("item")\n')
d=Path('data-updates.lua').read_text()
a=d.index('--Adding Fluidboxes')
b=d.index('--adding the asteroid spawn definitions',a)
Path('data-updates.lua').write_text(d[:a]+'-- Preserve pre-existing crusher fluidboxes and support K2SO machines.\nrequire("prototypes.compat.k2so_fluids")\n\n'+d[b:])
print('Upstream identifiers and loading order updated')
