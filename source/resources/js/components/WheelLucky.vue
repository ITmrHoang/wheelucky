<template>
    <div>

        <!-- <span>Prize {{ prizeLenght }}  number: {{ prizeNumber }}</span>
    <button
        type="button"
        @click="!rolling && prizeNumber < 8 && prizeNumber++"
        :disabled="rolling || prizeNumber === 8"
    >
        Add
    </button>
    <button
        type="button"
        @click="!rolling && prizeNumber > 2 && prizeNumber--"
        :disabled="rolling || prizeNumber === 2"
    >
        Remove
    </button> -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLongTitle"> {{ this.show?.noidung }}</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <div class="row flex justify-content-center">
              
                <div class="col-12 text-center">   <a :href="show.url" target="_blank">Mở</a> </div>
                <img :src="show.anh"  width="120px" height="120px" @click="openUrl(show.url)"/>
              </div>
            </div>
            <div class="modal-footer">
            </div>
          </div>
        </div>
      </div>
    <div class="wheel-wrapper">
        <div class="wheel-pointer" @click="onClickRotate">
             <button class="wheel__button">QUAY</button>
            </div>
        <div
            class="wheel-bg"
            :class="{ freeze: freeze }"
            :style="`transform: rotate(${wheelDeg}deg)`"
        >
            <div class="prize-list">
                <div
                    class="prize-item-wrapper"
                    v-for="(item, index) in prizeList"
                    :key="index"
                >
                    <div
                        class="prize-item"
                        :style="`
                        z-index:10;
                        position: relative;
                        background: ${item.mau ?? randomColor()};
                        transform: rotate(${
                            (360 / prizeList.length) * index
                        }deg)`
                        "
                    >
                        <!-- <div class="prize-name">
                            {{ item.name}}
                        </div> -->
                        <div class="prize-icon">
                            <img :src="item.anh"  width="40px" height="40px"/>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
export default {
    name: "WheelLucky",
    data() {
        return {
            show: {},
            background: "",
            freeze: false,
            rolling: false,
            clipath: "polygon(10px 0, 50% 100%, 132px 0)",
            width: '150px',
            wheelDeg: 0,
            prizeNumber: 6,
            prizeListOrigin:[
            ],
        };
    },
    computed: {
        prizeList() {
            return this.prizeListOrigin;
        },
        prizeLenght() {
            return this.prizeList.length
        }
    },
    methods: {
        randomColor() {
           return `#${Math.floor(Math.random()*16777215).toString(16)}`;
        },
        onClickRotate() {
            if (this.rolling) {
                return;
            }
            const result = Math.floor(Math.random() * this.prizeList.length);
            this.roll(result);
        },
        roll(result) {
            this.rolling = true;
            const { wheelDeg, prizeList } = this;
            this.wheelDeg =
                wheelDeg -
                (wheelDeg % 360) +
                6 * 360 +
                (360 - (360 / prizeList.length) * result);
                console.log(this.wheelDeg)
                this.show = prizeList[result]
            setTimeout(() => {
                this.rolling = false;
                // alert("Result：" + prizeList[result].name);
                $('#myModal').modal('show')
            }, 4500);
        },
        updateLength() {
            let _length = this.prizeLenght;
            console.log(_length,this.clipath)
            if(_length == 8){
                this.clipath = "polygon(10px 0, 50% 100%, 132px 0)";
            }
            else if(_length == 7){
                this.clipath ="polygon(3px 0, 50% 100%, 146px 0)"
            } else if(_length == 6) {
                this.clipath = "polygon(-9px 0, 50% 100%, 163px 0)"
            }
        },
        openUrl(url){
            console.log(url)
            window.open(url);
        }
    },
    watch: {
        prizeNumber() {
            this.freeze = true;
            this.wheelDeg = 0;

            setTimeout(() => {
                this.freeze = false;
            }, 0);
        },

    },
    created(){
    this.updateLength();
    axios.get('/data/data').then(res=> this.prizeListOrigin = res.data?.data ? JSON.parse(res.data.data) : [])
    axios.get('/data/background').then(res=> this.background = res.data?.data ?? '')
    },
    mounted() {

    }
};
</script>

<style>
html {
    background: v-bind(background);
}

.wheel-wrapper {
    width: 300px;
    height: 300px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}

.wheel-pointer {
    width: 51px;
    height: 51px;
    border-radius: 50%;
    background:#fff;
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    text-align: center;
    line-height: 50px;
    z-index: 2;
    cursor: pointer;
    border: solid 6px #fff;
    box-shadow: 0 4px 9px 0 rgba(0, 0, 0, 0.1);
    justify-content: center;
    align-items: center;
    font-family: 'Open sans', sans-serif;

    &::after {
        content: '';
            position: absolute;
            width: 0;
            height: 0;
            border: solid;
            border-width: 0 10px 20px;
            border-color: transparent;
            border-bottom-color: #fff;
            top: -15px;
            transform: translateX(-50%);
            
    }
}

.wheel__button {
    z-index: 10;
    position: absolute;
    width: 39px;
    height: 39px;
    background-color: lightgray;
    border: none;
    border-radius: 50%;
    cursor: pointer;
    transition: 0.3s;
    font-weight: 600;
    font-size: 10px;
    line-height: 13px;
    top:0;
    left: 0;
    &:hover {
        color: #27AE60;
    }
    &:active{
        border: solid 3px rgba(0, 0, 0, 0.1);
        font-size: 11px;
        line-height: 12px;
        width: 50px;
        height: 50px;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
    }
}
.wheel-bg {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    border: solid 6px #fff;
    box-shadow: 0 4px 9px 0 rgba(0, 0, 0, 0.1);
    overflow: hidden;
    transition: transform 4s ease-in-out;
    background: rgb(120, 118, 118);

    &.freeze {
        transition: none;
        background: red;
    }
}

.prize-list {
    width: 100%;
    height: 100%;
    position: relative;
    text-align: center;
}

.prize-item-wrapper {
    position: absolute;
    top: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 150px;
    height: 150px;
}

.prize-item {
    width: 150px;
    height: 150px;
    transform-origin: bottom;
    -webkit-clip-path: v-bind(clipath);
    clip-path:  v-bind(clipath);
    .prize-name {
        padding: 8px 0;
    }

    .prize-name {
        position: absolute;
        top: 6px;
        z-index: 20;
        width: 150px;
        color: azure;
        font-weight: 600;
        overflow: hidden;
    }
    .prize-icon {
        position: absolute;
        z-index: 10;
        top: 33px;
        width: 150px;
        overflow: hidden;
    }
}

</style>
