//切换网络环境
const apiConfig = {
	dev: {
		baseUrl: 'http://localhost:9090'//local
	},
	prod: {
		baseUrl: 'http://:9090'//web-server
	}
}
export default apiConfig