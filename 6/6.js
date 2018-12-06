const fs = require('fs');
const path = process.argv[2]


const content = fs.readFileSync(path).toString();
class Point{
  constructor(x, y, label){
    this.x = x;
    this.y = y;
    this.label = label;
  }

  distance(otherPoint){
    return Math.abs(this.x - otherPoint.x) + Math.abs(this.y - otherPoint.y)
  }

  translate({ x, y }){
    return new Point(this.x + x, this.y + y);
  }
}

const coords = content
  .split("\n")
  .map((v, i) => {
    const [x, y] = v.split(', ', 2).map(x => parseInt(x))
    return new Point(x, y, i);
  })

const bounds = coords.reduce(([t, r, b, l], {x, y}) => ([
  Math.min(t, y), 
  Math.max(r, x), 
  Math.max(b, y), 
  Math.min(l, x)]), [Infinity, 0, 0, Infinity]) 

function createMap(bounds){
  const map = [];
  for(var y = 0; y <= bounds[2]; y++){
    map[y] = [];
    for(var x = 0; x <= bounds[1]; x++){
      map[y][x] = { distance: Infinity, label: '.' };
    }
  }
  return map;
}

const map = createMap(bounds);


for(const p of coords){
  const entry = map[p.y][p.x];
  entry.label = p.label;
  entry.distance = 0;
}

function printMap(map){
  console.log(map.map(row => row.map(cell => cell.label).join('')).join("\n"), "\n\n")
  JSON.stringify({map})
}

function Bounds([top, right, bottom, left]){
  return function check({x, y}) {
    return x >= left && x <= right && y >= top && y <= bottom;
  }
}

inBounds = Bounds(bounds);
const printInBounds = point => inBounds(point) ? console.log(new Point(point)) : console.log('nope');

var counter = 0;
function mark(map, point, {label, distance}){
  if(inBounds(point)){
    const entry = map[point.y][point.x];
    if(entry.distance === distance && entry.label != label){
      entry.label = '.';
    }else if(distance < entry.distance){
      entry.label = label;
      entry.distance = distance;
      counter++;
    }
  }
}
function addMarker(map, point, marker) {
  if(inBounds(point)){
    map[point.y][point.x].label = marker;
  }
}

function markLevel(map, center, n, label){
  const value = {distance: n, label};
  coordsForLevel(center, n, coord => mark(map, coord, value));
}

function coordsForLevel(center, n, callback){
  for(let i = 0; i <= n; i++){
    const r = n - i;
    
    callback(center.translate({x: i, y: r}));
    callback(center.translate({x: -i, y: r}));
    callback(center.translate({x: i, y: -r}));
    callback(center.translate({x: -i, y: -r}));
  }
}

function flood(center, label){
  counter = Infinity
  for(var i = 1; counter > 0; i++){
    counter = 0;
    markLevel(map, center, i, label);
  }
}
for(var i = 0; i < coords.length; i++){
  flood(coords[i], i);
}

function histogram(map){
  const out = {};
  for(const row of map){
    for(const cell of row){
      out[cell.label] = (out[cell.label]||0) + 1;
    }
  }
  return out;
}

function findMax(histogram){
  return Object
    .entries(histogram)
    .filter(([key,]) => key != '.')
    .map(([, value]) => value)
    .reduce((max, n) => Math.max(max, n))
}

console.log('part1: ', findMax(histogram(map)));

const p2Map = createMap(bounds);
const center = new Point(Math.round((bounds[1]-bounds[3])/2 + bounds[3]), Math.round((bounds[2]-bounds[0])/2 + bounds[0]), 'center');
console.log(center);

addMarker(p2Map, center, 'x');
counter = Infinity;
const threshold = 10000;
for(var i = 1; counter > 0; i++){
  counter = 0;
  coordsForLevel(center, i, p => {
    const distance = coords.reduce((sum, p2) => sum + p.distance(p2), 0);
    if(distance < threshold){
      addMarker(p2Map, p, 'x')
      counter++;
    }
  })
}
printMap(p2Map);
console.log(histogram(p2Map));
