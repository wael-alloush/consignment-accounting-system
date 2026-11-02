import { apiClient } from '../../../shared/api/apiAxios.js';
export async function getTenantsRequest() {
  const { data } = await apiClient.get('/tenants/get-tenants');
  if (data.success) {
    return data.data;
  } else {
    throw new Error(data.message);
  }
}