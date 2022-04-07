function sync() {
	let i = 1;
	while (i < 10)
		i++;
	setTimeout(console.log("run"),1000);
	return ((i % 2) ? 1 : 0);
}

const sync_promise = new Promise((res, rej) => {
	let	ret = 0;
	console.log("1");
	(ret = sync()) ? res(ret) : rej("ERROR");
	console.log("2");
});

console.log("3", sync_promise);
sync_promise.then((data) => console.log(data)).catch((err)=>console.log(err));

