<template>
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-8">
        <div class="card">
          <div class="card-header">Thiết lập dữ liệu: {{ ListLength }}</div>

          <div class="card-body" style="position: relative">
            <div style="position: sticky;"> <button @click="add"> thêm</button></div>
            <form>
              <div class="form-group">
                <label for="maunen">Mầu nền</label>
                <input type="text" id="maunen" v-model="background">
              </div>

              <div class="row" v-for="item, index in data">
                <div class="col-12"> <button type="button" @click="remove(index)">xóa</button></div>
                <h1 class="col-12">Item {{ index + 1 }}</h1>
                <div class="col-12 form-group">
                  <label for="noidung">Nội dung thông báo</label>
                  <input type="text" class="form-control" @change="e=> onChange(e,index)" name="noidung" :value="item.noidung" />
                </div>
                <div class="form-group col-12">
                  <label for="url">Đường dẫn</label>
                  <input type="text" class="form-control"  @change="e=> onChange(e,index)"  name="url" :value="item.url" />
                </div>
                <div class="form-group col-12">
                  <label for="mau">Mầu</label>
                  <input type="text" class="form-control"   @change="e=> onChange(e,index)"   name="mau" pattern="#([a-f0-9]{6}|[a-f0-9]{3})" :value="item.mau" />
                </div>
                <div class="form-group col-12">
                  <label for="file">Ảnh</label>
                  <input
                    type="file"
                    accept="image/png, image/jpeg"
                    class="form-control"
                    @change="(e) => onFileChange(e, index)"
                    id="file"
                  />
                  <div style="width:128px; height: 128px">
                    <img :src="item.anh" alt="anh" style="width:128px; height: 128px">

                  </div>
                </div>
              </div>

              <button type="button" @click="handleSummit" class="btn btn-primary">Submit</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>


<script>
const initState = {
    url: '',
    noidung: '',
    mau: '',
    anh: ''

}
export default {
  name: "SettingData",
  data() {
    const csrf = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
    return {
      background: "",
      data: [
      ],
      csrf,
    };
  },
  computed: {
    ListLength() {
      return this.data.length;
    },
  },
  methods: {
    onFileChange(e, index) {
      let files = e.target.files || e.dataTransfer.files;
      if (!files.length) return;
      this.readFile(files[0]).then(val => {
        this.data[index].anh = val
      });
    },
    onChange(e,index) {
       let name = e.target.name;
       let val = e.target.value;
       this.data[index][name] = val;
    },
    readFile(file) {
        return new Promise((resolve, reject) => {
        const fileReader = new FileReader();
        fileReader.readAsDataURL(file);

        fileReader.onload = () => {
            resolve(fileReader.result);
        };

        fileReader.onerror = (error) => {
            reject(error);
        };
    });
    },
    add() {
        this.data.push({...initState})
    },
    remove(index){
        console.log(index)
        const _data = [...this.data];
        _data.splice(index,1)
        this.data = _data;
    },
    handleSummit() {
       let _check = this.data.length;
       if(this.background) axios.post('/data', {name: 'background', data: this.background})
       if(_check >=6 && _check <=8) {
        axios.post('/data', {name: 'data', data: [...this.data]}).then(res => window.location.reload())
       } else {
        alert("nhập >= 6 và <=8 item")
       }
    }

  },
  beforeCreate() {
    axios.get('/data/data').then(res=> this.data = res.data?.data ? JSON.parse(res.data.data) : [])
    axios.get('/data/background').then(res=> this.background = res.data?.data ?? '')

  },
};
</script>
